//
//  NetworkMonitor.swift
//  SpeedoTransfer
//
//  Created by Merna Islam on 14/09/2024.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global()
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}


