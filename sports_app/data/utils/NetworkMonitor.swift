//
//  NetworkMonitor.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//


import Foundation
import Alamofire

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let reachabilityManager = NetworkReachabilityManager()
    
    #if DEBUG
    var mockIsConnected: Bool?
    #endif
    
    var isConnected: Bool {
        #if DEBUG
        if let mock = mockIsConnected {
            return mock
        }
        #endif
        return reachabilityManager?.isReachable ?? false
    }
    
    private init() {}
    
    func startMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable, .unknown:
                print("Network is offline")
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                print("Network is online")
            }
        }
    }
}