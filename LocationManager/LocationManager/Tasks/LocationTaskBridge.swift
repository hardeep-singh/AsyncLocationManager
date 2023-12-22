//
//  LocationTaskBridge.swift
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
    
    // MARK: - Location Monitoring
    case locationUpdatesPaused
    case locationUpdatesResumed
    case didUpdateLocations(locations: [CLLocation])
    
    // MARK: - Failures
    case didFailWithError(_ error: Error)
    
    // MARK: - Region Monitoring
    case didEnterRegion(_ region: CLRegion)
    case didExitRegion(_ region: CLRegion)
    case didStartMonitoringFor(_ region: CLRegion)
    case monitoringDidFailFor(region: CLRegion?, error: Error)
}

actor LocationTaskBridge {
    
    private var tasks = [String: AnyLocationTask]()
    
    nonisolated
    private func keyForObject(task: AnyLocationTask) -> String {
        let type = type(of: task)
        return String(describing: type)
    }
    
    func add(task: AnyLocationTask) {
        self.tasks[keyForObject(task: task)] = task
    }
    
    func remove(task: AnyLocationTask.Type) {
        self.tasks.removeValue(forKey:  String(describing: task))
    }
    
    /// - Parameter event: event to dispatch.
    nonisolated
    func dispatchEvent(event: LocationBridgeEvent) {
        Task {
            for task in await tasks.values {
                task.received(event: event)
            }
        }
    }

}
