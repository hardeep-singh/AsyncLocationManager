//
//  LocationDelegate.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

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
    
    // MARK: - Location Updates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationTaskBridge.dispatchEvent(event: .didFailWithError(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationTaskBridge.dispatchEvent(event: .didUpdateLocations(locations: locations))
    }
    
    // MARK: - Pause/Resume
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        locationTaskBridge.dispatchEvent(event: .locationUpdatesPaused)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        locationTaskBridge.dispatchEvent(event: .locationUpdatesResumed)
    }
    
    // MARK: - Region Monitoring
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        locationTaskBridge.dispatchEvent(event: .monitoringDidFailFor(region: region, error: error))
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationTaskBridge.dispatchEvent(event: .didEnterRegion(region))
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationTaskBridge.dispatchEvent(event: .didExitRegion(region))
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationTaskBridge.dispatchEvent(event: .didStartMonitoringFor(region))
    }
    
}
