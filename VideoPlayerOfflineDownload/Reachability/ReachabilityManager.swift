//
//  File.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 14/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit

public class ReachabilityManager: NSObject {
    public static let shared = ReachabilityManager()
    
    public var isConnectedToNetwork:Bool {
        return networkManager?.isReachable ?? false
    }
    
    public var currentInternetConection:String {
        return currentConnectionType()
    }
    
    public var checkNetworkConnection:Bool {
        return showAlertForNoNetworkConnectivity()
    }
    
    public func connectionType() -> String? {
        if networkManager?.isReachableOnCellular == true {
            return "MOBILE"
        } else if networkManager?.isReachableOnEthernetOrWiFi == true {
            return "WIFI"
        }
        return nil
    }
    
    private let networkManager = NetworkReachabilityManager()
    private override init() {}
    
    public func setUpReachabilityObserver() {
        networkManager?.startListening(onUpdatePerforming: { (_ ) in
            NotificationCenter.default.post(name: Notification.Name("reachabilityChanged"), object: nil)
        })
    }
    
    private func showAlertForNoNetworkConnectivity() -> Bool {
        //TODO remove this legacy dependency across the flows
        if let isReachable = networkManager?.isReachable, isReachable {
            return true
        } else {
            DispatchQueue.main.async {
                if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    let alertVC = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(okAction)
                   // rootViewController.present(alertVC, animated: true, completion: nil)
                }
            }
            return false
        }
    }
    
    private func currentConnectionType() -> String {
        var connectionType:String = "unknown"
        if let isReachable = networkManager?.isReachable, isReachable {
            if let isReachableOnEthernetOrWiFi = networkManager?.isReachableOnEthernetOrWiFi, isReachableOnEthernetOrWiFi {
                connectionType = "WIFI"
            } else {
                let netInfo = CTTelephonyNetworkInfo()
                if let cRAT = netInfo.currentRadioAccessTechnology  {
                    switch cRAT {
                    case CTRadioAccessTechnologyGPRS,
                         CTRadioAccessTechnologyEdge,
                         CTRadioAccessTechnologyCDMA1x:
                        connectionType = "2G"
                    case CTRadioAccessTechnologyWCDMA,
                         CTRadioAccessTechnologyHSDPA,
                         CTRadioAccessTechnologyHSUPA,
                         CTRadioAccessTechnologyCDMAEVDORev0,
                         CTRadioAccessTechnologyCDMAEVDORevA,
                         CTRadioAccessTechnologyCDMAEVDORevB,
                         CTRadioAccessTechnologyeHRPD:
                        connectionType = "3G"
                    case CTRadioAccessTechnologyLTE:
                        connectionType = "4G"
                    default:
                        connectionType = "unknown"
                    }
                }
            }
        } else {
            connectionType = "Not Reachable"
        }
        return connectionType
    }
    
    deinit {
        networkManager?.stopListening()
    }
}

