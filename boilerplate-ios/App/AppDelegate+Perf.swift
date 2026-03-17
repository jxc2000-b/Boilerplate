// AppDelegate+Perf.swift
// boilerplate-ios
//
// Provides a UIApplicationDelegate that wires up PerformanceMonitor.
// boilerplate_iosApp adopts this delegate via @UIApplicationDelegateAdaptor.

import UIKit
import os.log

// MARK: - AppDelegate

/// Minimal UIApplicationDelegate used to hook lifecycle events from SwiftUI.
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        #if DEBUG
        startPerformanceMonitoring()
        #endif
        return true
    }
}

// MARK: - Performance Monitoring

extension AppDelegate {

    /// Configures and starts `PerformanceMonitor`.
    /// Called automatically in `application(_:didFinishLaunchingWithOptions:)` during DEBUG builds.
    func startPerformanceMonitoring() {
        let log = OSLog(
            subsystem: Bundle.main.bundleIdentifier ?? "com.boilerplate",
            category: "Performance"
        )

        PerformanceMonitor.shared.onSnapshot = { snapshot in
            // Snapshot data is already logged by PerformanceMonitor via os_log.
            // Add custom handling here — e.g. send to analytics or write to a file.
            //
            // Example threshold alert:
            if snapshot.totalCPUPercent > 80 {
                os_log(
                    "⚠️ High CPU: %.1f%% — check top threads: %{public}@",
                    log: log,
                    type: .error,
                    snapshot.totalCPUPercent,
                    snapshot.topThreadCPU
                        .map { "thread \($0.threadID): \(String(format: "%.1f", $0.cpuPercent))%" }
                        .joined(separator: ", ")
                )
            }
        }

        // Sample every second. Increase the interval to reduce overhead.
        PerformanceMonitor.shared.start(interval: 1.0)
    }
}
