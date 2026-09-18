import Flutter
import UIKit
import Network
import Darwin

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var scanRun: IOSScanRun?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let discovery = FlutterMethodChannel(name: "network_guardian/discovery", binaryMessenger: controller.binaryMessenger)
    let events = FlutterEventChannel(name: "network_guardian/events", binaryMessenger: controller.binaryMessenger)
    let diagnostics = FlutterMethodChannel(name: "network_guardian/diagnostics", binaryMessenger: controller.binaryMessenger)
    events.setStreamHandler(self)

    discovery.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "network":
        do { result(try self.networkInfo()) } catch { result(FlutterError(code: "network_unavailable", message: error.localizedDescription, details: nil)) }
      case "permission":
        // iOS presents Local Network permission when sockets are first used.
        result(true)
      case "start":
        guard self.scanRun == nil else { result(FlutterError(code: "busy", message: "A scan is already running", details: nil)); return }
        guard let args = call.arguments as? [String: Any], let runId = args["runId"] as? String else {
          result(FlutterError(code: "arguments", message: "Missing run identifier", details: nil)); return
        }
        do {
          let info = try self.networkInfo()
          let run = IOSScanRun(info: info, runId: runId) { [weak self] payload in self?.emit(payload) }
          self.scanRun = run
          run.start { [weak self] in self?.scanRun = nil }
          result(nil)
        } catch {
          result(FlutterError(code: "network_unavailable", message: error.localizedDescription, details: nil))
        }
      case "cancel":
        self.scanRun?.cancel()
        self.scanRun = nil
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    }

    diagnostics.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      guard let args = call.arguments as? [String: Any] else { result(FlutterError(code: "arguments", message: "Missing arguments", details: nil)); return }
      switch call.method {
      case "ping":
        guard let ip = args["ip"] as? String else { result(FlutterError(code: "arguments", message: "IP required", details: nil)); return }
        self.tcpPing(ip: ip, count: min(max(args["count"] as? Int ?? 4, 1), 10), result: result)
      case "probeServices":
        guard let ip = args["ip"] as? String else { result(FlutterError(code: "arguments", message: "IP required", details: nil)); return }
        self.probe(ip: ip, result: result)
      case "wakeOnLan":
        result(FlutterError(code: "unsupported", message: "Wake-on-LAN from iOS requires additional platform validation and is disabled in this checkpoint.", details: nil))
      case "networkStatus":
        result(FlutterError(code: "unsupported", message: "Network Doctor Internet validation is not yet validated on iOS in this checkpoint.", details: nil))
      default: result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  private func emit(_ payload: [String: Any]) {
    DispatchQueue.main.async { [weak self] in self?.eventSink?(payload) }
  }

  private func networkInfo() throws -> [String: Any?] {
    var address: String?
    var prefix = 24
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { throw NSError(domain: "Guardian", code: 1, userInfo: [NSLocalizedDescriptionKey: "Wi-Fi interface information is unavailable"]) }
    defer { freeifaddrs(ifaddr) }
    var cursor: UnsafeMutablePointer<ifaddrs>? = first
    while let item = cursor {
      let name = String(cString: item.pointee.ifa_name)
      let family = item.pointee.ifa_addr.pointee.sa_family
      if name == "en0" && family == UInt8(AF_INET) {
        var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        getnameinfo(item.pointee.ifa_addr, socklen_t(item.pointee.ifa_addr.pointee.sa_len), &host, socklen_t(host.count), nil, 0, NI_NUMERICHOST)
        address = String(cString: host)
        if let mask = item.pointee.ifa_netmask {
          let sin = UnsafeRawPointer(mask).assumingMemoryBound(to: sockaddr_in.self).pointee
          prefix = sin.sin_addr.s_addr.bigEndian.nonzeroBitCount
        }
        break
      }
      cursor = item.pointee.ifa_next
    }
    guard let ip = address else { throw NSError(domain: "Guardian", code: 2, userInfo: [NSLocalizedDescriptionKey: "Connect to Wi-Fi before scanning"]) }
    return ["ip": ip, "prefix": prefix, "gateway": nil, "interface": "en0", "ssid": nil, "bssid": nil, "token": "en0:\(ip)/\(prefix)", "boot": 0]
  }

  private func tcpPing(ip: String, count: Int, result: @escaping FlutterResult) {
    let queue = DispatchQueue(label: "guardian.ios.ping")
    queue.async {
      var values: [Double] = []
      for _ in 0..<count {
        let sem = DispatchSemaphore(value: 0)
        let started = DispatchTime.now()
        let connection = NWConnection(host: NWEndpoint.Host(ip), port: 443, using: .tcp)
        var success = false
        connection.stateUpdateHandler = { state in
          switch state {
          case .ready: success = true; sem.signal()
          case .failed, .cancelled: sem.signal()
          default: break
          }
        }
        connection.start(queue: queue)
        _ = sem.wait(timeout: .now() + 1)
        connection.cancel()
        if success {
          let ns = DispatchTime.now().uptimeNanoseconds - started.uptimeNanoseconds
          values.append(Double(ns) / 1_000_000.0)
        }
      }
      let avg = values.isEmpty ? nil : values.reduce(0, +) / Double(values.count)
      DispatchQueue.main.async {
        result(["sent": count, "received": values.count, "minMs": values.min(), "avgMs": avg, "maxMs": values.max(), "method": "TCP reachability (443)"])
      }
    }
  }

  private func probe(ip: String, result: @escaping FlutterResult) {
    let ports: [(UInt16, String)] = [(22,"SSH"),(80,"HTTP"),(443,"HTTPS"),(445,"SMB"),(554,"RTSP"),(631,"IPP"),(3389,"Remote Desktop"),(8008,"Chromecast/HTTP"),(8009,"Chromecast"),(9100,"Printer (JetDirect)")]
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "guardian.ios.probe")
    let lock = NSLock()
    var open: [[String: Any]] = []
    for (port, name) in ports {
      group.enter()
      let connection = NWConnection(host: NWEndpoint.Host(ip), port: NWEndpoint.Port(rawValue: port)!, using: .tcp)
      var finished = false
      func done(_ success: Bool) {
        lock.lock(); defer { lock.unlock() }
        if finished { return }; finished = true
        if success { open.append(["port": Int(port), "name": name]) }
        connection.cancel(); group.leave()
      }
      connection.stateUpdateHandler = { state in
        switch state { case .ready: done(true); case .failed, .cancelled: done(false); default: break }
      }
      connection.start(queue: queue)
      queue.asyncAfter(deadline: .now() + 0.4) { done(false) }
    }
    group.notify(queue: .main) { result(open.sorted { ($0["port"] as! Int) < ($1["port"] as! Int) }) }
  }
}

private final class IOSScanRun {
  private let info: [String: Any?]
  private let runId: String
  private let emit: ([String: Any]) -> Void
  private var cancelled = false
  private let queue = OperationQueue()

  init(info: [String: Any?], runId: String, emit: @escaping ([String: Any]) -> Void) {
    self.info = info; self.runId = runId; self.emit = emit
    queue.maxConcurrentOperationCount = 32
  }

  func start(completion: @escaping () -> Void) {
    guard let ip = info["ip"] as? String, let prefix = info["prefix"] as? Int, prefix >= 16 else {
      emit(["kind":"error","message":"Unsupported IPv4 subnet","runId":runId]); completion(); return
    }
    let parts = ip.split(separator: ".").compactMap { Int($0) }
    guard parts.count == 4 else { emit(["kind":"error","message":"Invalid IPv4 address","runId":runId]); completion(); return }
    let local = UInt32(parts[0] << 24 | parts[1] << 16 | parts[2] << 8 | parts[3])
    let mask: UInt32 = prefix == 0 ? 0 : UInt32.max << UInt32(32-prefix)
    let base = local & mask
    let end = base | ~mask
    let first = prefix >= 31 ? base : base + 1
    let last = prefix >= 31 ? end : end - 1
    if last - first + 1 > 4096 { emit(["kind":"error","message":"Subnet exceeds the 4,096-host scan limit","runId":runId]); completion(); return }
    let total = Int(last-first+1)
    var scanned = 0
    let lock = NSLock()
    for raw in first...last {
      queue.addOperation { [weak self] in
        guard let self, !self.cancelled else { return }
        let target = "\((raw >> 24) & 255).\((raw >> 16) & 255).\((raw >> 8) & 255).\(raw & 255)"
        if target == ip { self.emit(["kind":"device","ip":target,"source":"Local interface","runId":self.runId]) }
        else if self.reachable(target) { self.emit(["kind":"device","ip":target,"source":"TCP reachability","runId":self.runId]) }
        lock.lock(); scanned += 1; let current = scanned; lock.unlock()
        self.emit(["kind":"progress","scanned":current,"runId":self.runId])
      }
    }
    DispatchQueue.global().async { [weak self] in
      guard let self else { return }
      self.queue.waitUntilAllOperationsAreFinished()
      if self.cancelled { self.emit(["kind":"cancelled","runId":self.runId]) }
      else { self.emit(["kind":"completed","runId":self.runId]) }
      completion()
    }
  }

  func cancel() { cancelled = true; queue.cancelAllOperations() }

  private func reachable(_ ip: String) -> Bool {
    for p: UInt16 in [80, 443] {
      let sem = DispatchSemaphore(value: 0)
      let q = DispatchQueue(label: "guardian.ios.reach.\(ip).\(p)")
      let c = NWConnection(host: NWEndpoint.Host(ip), port: NWEndpoint.Port(rawValue: p)!, using: .tcp)
      var ok = false
      c.stateUpdateHandler = { state in
        switch state { case .ready: ok = true; sem.signal(); case .failed, .cancelled: sem.signal(); default: break }
      }
      c.start(queue: q)
      _ = sem.wait(timeout: .now() + 0.25)
      c.cancel()
      if ok { return true }
    }
    return false
  }
}
