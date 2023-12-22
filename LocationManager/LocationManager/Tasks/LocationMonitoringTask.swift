//
//  LocationMonitoringTask.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

public class LocationMonitoringTask: AnyLocationTask {
        
    public enum LocationStreamResult {
        case didUpdateLocations(_ locations: [CLLocation])
        case didFailWithError(_ error: Error)
        case didResume
        case didPaused
    }
    
    public typealias Stream = AsyncStream<LocationStreamResult>
    public var stream: Stream.Continuation?
    
    func received(event: LocationBridgeEvent) {
        switch event {
        case .locationUpdatesPaused:
            stream?.yield(.didPaused)
            
        case .locationUpdatesResumed:
            stream?.yield(.didResume)
            
        case let .didFailWithError(error):
            stream?.yield(.didFailWithError(error))
            
        case let .didUpdateLocations(locations):
            stream?.yield(.didUpdateLocations(locations))
            
        default:
            break
        }
    }
}
