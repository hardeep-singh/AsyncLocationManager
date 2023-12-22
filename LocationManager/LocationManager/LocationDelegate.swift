//
//  LocationDelegate.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

public enum LocationBridgeEvent {
    
    // MARK: - Authorization
    case didChangeLocationEnabled(_ enabled: Bool)
    case didChangeAuthorization(_ status: CLAuthorizationStatus)
    
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    
    weak var locationTaskBridge: LocationTaskBridge!
    init(locationTaskBridge: LocationTaskBridge) {
        self.locationTaskBridge = locationTaskBridge
    }
    
    // MARK: - Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            locationTaskBridge.dispatchEvent(event: .didChangeAuthorization(manager.authorizationStatus))
        } else {
            // Fallback on earlier versions
            locationTaskBridge.dispatchEvent(event: .didChangeAuthorization(CLLocationManager.authorizationStatus()))
        }
    }
    
}
