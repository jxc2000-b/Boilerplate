// PerformanceMonitor.swift
// boilerplate-ios
//
// Lightweight in-app performance monitor.
// Samples CPU usage, memory footprint, and main-thread hitch estimates
// on a configurable interval using Mach task/thread APIs.
// Intended for debug/development use only — disable in production builds.

import Foundation
import os.log
import QuartzCore
import MachO

final class PerformanceMonitor {

    // MARK: - Shared Instance

    static let shared = PerformanceMonitor()

    // MARK: - Snapshot

    /// A single point-in-time capture of key performance metrics.
    struct Snapshot {
        /// Wall-clock time of the capture.
        let timestamp: Date
        /// Sum of CPU usage across all threads (can exceed 100 % on multi-core).
        let totalCPUPercent: Double
        /// Physical memory footprint reported by the kernel (phys_footprint).
        let residentMemoryMB: Double
        /// Total virtual address space reserved by the process.
        let virtualMemoryMB: Double
        /// Estimated main-thread frame overrun in milliseconds.
        /// Values above 0 suggest a hitch occurred since the last sample.
        let mainThreadHitchMs: Double
        /// Top N threads sorted by descending CPU usage.
        let topThreadCPU: [(threadID: UInt64, cpuPercent: Double)]
    }

    // MARK: - Public API

    /// Called on the monitoring queue each time a new snapshot is captured.
    var onSnapshot: ((Snapshot) -> Void)?

    /// Starts periodic sampling.
    /// - Parameter interval: Seconds between samples (default 1.0).
    func start(interval: TimeInterval = 1.0) {
        stop()

        // Reset the hitch baseline so the first sample isn't artificially large.
        lastTickTime = CACurrentMediaTime()

        let t = DispatchSource.makeTimerSource(queue: monitorQueue)
        t.schedule(deadline: .now(), repeating: interval)
        t.setEventHandler { [weak self] in
            guard let self else { return }
            let snap = self.captureSnapshot()
            self.onSnapshot?(snap)

            os_log(
                "[PERF] CPU: %.1f%% | Mem: %.1f MB | VM: %.1f MB | Hitch: %.1f ms | Top: %{public}@",
                log: Self.log,
                type: .debug,
                snap.totalCPUPercent,
                snap.residentMemoryMB,
                snap.virtualMemoryMB,
                snap.mainThreadHitchMs,
                snap.topThreadCPU
                    .map { "(\($0.threadID): \(String(format: "%.1f", $0.cpuPercent))%)" }
                    .joined(separator: ", ")
            )
        }
        timer = t
        t.resume()
    }

    /// Stops periodic sampling.
    func stop() {
        timer?.cancel()
        timer = nil
    }

    // MARK: - Private State

    private init() {}

    private let monitorQueue = DispatchQueue(label: "com.boilerplate.perf.monitor", qos: .utility)
    private var timer: DispatchSourceTimer?
    /// Timestamp of the previous sample tick used for hitch estimation.
    private var lastTickTime: CFTimeInterval = CACurrentMediaTime()

    private static let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.boilerplate", category: "Performance")
    /// Ideal frame budget at 60 Hz in milliseconds.
    private static let frameBudgetMs60Hz: Double = 16.67
    /// Multiplier to convert seconds to milliseconds.
    private static let secondsToMs: Double = 1_000.0

    // MARK: - Snapshot Capture

    private func captureSnapshot() -> Snapshot {
        let cpu      = Self.processCPUUsage()
        let mem      = Self.memoryUsage()
        let hitch    = hitchEstimate()
        let topCPU   = Self.topThreadsByCPU(limit: 5)

        return Snapshot(
            timestamp: Date(),
            totalCPUPercent: cpu,
            residentMemoryMB: mem.residentMB,
            virtualMemoryMB: mem.virtualMB,
            mainThreadHitchMs: hitch,
            topThreadCPU: topCPU
        )
    }

    // MARK: - CPU (process total)

    /// Returns the summed CPU usage of all non-idle threads in the process.
    private static func processCPUUsage() -> Double {
        var threadsList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0

        guard task_threads(mach_task_self_, &threadsList, &threadCount) == KERN_SUCCESS,
              let threads = threadsList else { return 0 }

        defer {
            // Deallocate the thread port array returned by task_threads(2).
            let size = vm_size_t(Int(threadCount) * MemoryLayout<thread_t>.stride)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threads), size)
        }

        var total: Double = 0
        for i in 0..<Int(threadCount) {
            total += cpuUsage(for: threads[i])
        }
        return total
    }

    // MARK: - CPU (top threads)

    /// Returns the top `limit` threads sorted by descending CPU usage.
    private static func topThreadsByCPU(limit: Int) -> [(UInt64, Double)] {
        var threadsList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0

        guard task_threads(mach_task_self_, &threadsList, &threadCount) == KERN_SUCCESS,
              let threads = threadsList else { return [] }

        defer {
            let size = vm_size_t(Int(threadCount) * MemoryLayout<thread_t>.stride)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threads), size)
        }

        var result: [(UInt64, Double)] = []
        for i in 0..<Int(threadCount) {
            let thread = threads[i]
            let cpu = cpuUsage(for: thread)
            guard cpu > 0 else { continue }
            result.append((UInt64(thread), cpu))
        }

        return result.sorted { $0.1 > $1.1 }.prefix(limit).map { $0 }
    }

    /// Reads THREAD_BASIC_INFO for a single thread and returns its CPU percentage.
    private static func cpuUsage(for thread: thread_act_t) -> Double {
        var info = thread_basic_info()
        var infoCount = mach_msg_type_number_t(THREAD_INFO_MAX)

        let kr: kern_return_t = withUnsafeMutablePointer(to: &info) { rawPtr in
            rawPtr.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) {
                thread_info(thread, thread_flavor_t(THREAD_BASIC_INFO), $0, &infoCount)
            }
        }

        guard kr == KERN_SUCCESS else { return 0 }
        guard (info.flags & TH_FLAGS_IDLE) == 0 else { return 0 }
        return Double(info.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
    }

    // MARK: - Memory

    /// Returns physical footprint and virtual size in megabytes.
    private static func memoryUsage() -> (residentMB: Double, virtualMB: Double) {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(
            MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size
        )

        let kr: kern_return_t = withUnsafeMutablePointer(to: &info) { rawPtr in
            rawPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }

        guard kr == KERN_SUCCESS else { return (0, 0) }
        return (
            Double(info.phys_footprint) / 1_048_576,
            Double(info.virtual_size)   / 1_048_576
        )
    }

    // MARK: - Main-thread Hitch Estimate

    /// Estimates the frame overrun on the main thread since the last call.
    /// Compares elapsed wall time against an ideal 60 Hz frame budget (≈16.67 ms).
    /// Run on the monitor queue so deltas reflect real elapsed time between samples.
    private func hitchEstimate() -> Double {
        let now   = CACurrentMediaTime()
        let delta = (now - lastTickTime) * Self.secondsToMs  // convert to ms
        lastTickTime = now
        // Positive value means we overran the nominal frame budget.
        return max(0, delta - Self.frameBudgetMs60Hz)
    }
}
