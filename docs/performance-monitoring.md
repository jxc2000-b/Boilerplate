# Performance Monitoring

## Overview

Two Swift files add lightweight in-app performance sampling to the boilerplate project:

| File | Location | Purpose |
|------|----------|---------|
| `PerformanceMonitor.swift` | `boilerplate-ios/Utilities/` | Singleton sampler — CPU, memory, hitch detection |
| `AppDelegate+Perf.swift` | `boilerplate-ios/App/` | UIApplicationDelegate + wiring helper |

Monitoring runs **only in `DEBUG` builds** and is never active in App Store / production releases.

---

## Files Added

### `PerformanceMonitor.swift`

A singleton (`PerformanceMonitor.shared`) that fires a `DispatchSourceTimer` on a background utility queue. Each tick calls Mach task/thread APIs, assembles a `Snapshot`, invokes `onSnapshot`, and writes a single `os_log` line visible in Xcode's console and macOS Console.app.

### `AppDelegate+Perf.swift`

Defines the `AppDelegate` class (adopted by `boilerplate_iosApp` via `@UIApplicationDelegateAdaptor`) and an extension containing `startPerformanceMonitoring()`. The method configures `PerformanceMonitor.shared.onSnapshot` and calls `start(interval:)`.

---

## Wiring Up

`boilerplate_iosApp.swift` was updated to inject the delegate:

```swift
@main
struct boilerplate_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
```

`AppDelegate.application(_:didFinishLaunchingWithOptions:)` calls `startPerformanceMonitoring()` automatically inside a `#if DEBUG` guard, so no additional call-site changes are needed.

If you ever want to start/stop monitoring manually elsewhere in the app:

```swift
// Start with a custom interval (e.g. 2 seconds)
PerformanceMonitor.shared.start(interval: 2.0)

// Stop when navigating away from a heavy screen
PerformanceMonitor.shared.stop()
```

---

## Metrics Explained

| Metric | Field | What it measures |
|--------|-------|-----------------|
| **Total CPU %** | `totalCPUPercent` | Sum of `cpu_usage / TH_USAGE_SCALE * 100` across all non-idle threads. Can exceed 100 % on multi-core devices (max ≈ `numberOfCores × 100`). |
| **Resident Memory MB** | `residentMemoryMB` | `phys_footprint` from `TASK_VM_INFO` — the "real" memory the OS attributes to your app. This is what the system uses for memory-pressure decisions. |
| **Virtual Memory MB** | `virtualMemoryMB` | Total virtual address space reserved. Usually much larger than resident; high values alone are not alarming. |
| **Main-Thread Hitch ms** | `mainThreadHitchMs` | Wall-time overrun beyond the 16.67 ms (60 Hz) budget per sample tick. A positive value indicates the monitor queue was blocked, which can loosely correlate with main-thread hangs. Use Instruments → Hangs for precise hitch attribution. |
| **Top Thread CPU** | `topThreadCPU` | Up to 5 threads with the highest `cpu_usage`, sorted descending. Each entry is `(threadID: UInt64, cpuPercent: Double)`. Thread IDs match Mach port numbers visible in Instruments. |

---

## Identifying Culprits with Instruments

### CPU hotspots → Time Profiler
1. Product → Profile (⌘I) → choose **Time Profiler**.
2. Reproduce the high-CPU scenario.
3. In the call tree, enable **Hide System Libraries** and **Separate by Thread**.
4. The heaviest frames at the top of each thread's stack are the culprits.
5. Cross-reference with `topThreadCPU` thread IDs — they map to the Mach port column in the Threads instrument.

### Memory leaks & growth → Allocations / Leaks
1. Profile → **Allocations** to track live objects over time; look for unbounded growth.
2. Profile → **Leaks** fires automatically when it detects retain cycles; click a leak to see the allocation back-trace.
3. Watch `residentMemoryMB` from the monitor — a steady climb that never drops back is a strong leak signal.

### UI hangs → Hangs instrument
1. Profile → **Hangs** (Xcode 14+).
2. Any hang > 250 ms is flagged with a call stack showing what blocked the main thread.
3. Correlate with `mainThreadHitchMs` spikes to confirm which screens are worst.

---

## Overhead & Caveats

- **CPU cost**: Each sample calls `task_threads(2)` and `thread_info(2)` once per thread. On a typical app with < 20 threads at 1 Hz, this adds < 0.5 % CPU overhead.
- **Memory cost**: No heap allocations per sample beyond the `Snapshot` struct and the temporary thread-port array (deallocated immediately).
- **Timer granularity**: `DispatchSourceTimer` on a `.utility` QoS queue; real-world jitter is usually < 5 ms at 1 Hz — acceptable for sampling.
- **`#if DEBUG` guard**: The `startPerformanceMonitoring()` call in `AppDelegate` is wrapped in `#if DEBUG`. The `PerformanceMonitor` class itself is compiled into all configurations, but unless `start()` is called it does nothing.
- **Production usage**: If you need production monitoring, integrate a dedicated SDK (e.g. Firebase Performance, Datadog, or Sentry) instead of this lightweight sampler.
- **Thread IDs**: The `threadID` values in `topThreadCPU` are Mach port numbers, not POSIX `pthread_t` handles. They are stable within a process lifetime but not across launches.
