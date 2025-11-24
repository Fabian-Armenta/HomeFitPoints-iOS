//
//  ConnectivityService.swift
//  HomeFitPoints
//
//  Created by Fabian Armenta on 18/11/25.
//

import Foundation
import Network
import UIKit

extension Notification.Name {
    static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}

class ConnectivityService {
    static let shared = ConnectivityService()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")
    
    var isConnected: Bool = true
    var isCellular: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let newState = path.status == .satisfied
            let newIsCellular = path.usesInterfaceType(.cellular)
            
            if newState != self.isConnected || newIsCellular != self.isCellular {
                self.isConnected = newState
                self.isCellular = newIsCellular
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .connectivityStatusChanged,
                        object: nil
                    )
                }
            }
        }
        monitor.start(queue: queue)
    }
}
