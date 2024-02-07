//
//  LocationAuthorizationMonitoringTask.swift
//  AsyncLocationManager
//
//  Created by Hardeep Singh on 7/02/24.
//

import Foundation
import CoreLocation

public class AuthorizationMonitoringTask: AnyLocationTask {
        
    public enum LocationStreamResult {
        case didUpdateLocations(_ locations: [CLLocation])
        case didFailWithError(_ error: Error)
        case didResume
        case didPaused
    }
    
    public typealias Stream = AsyncStream<CLAuthorizationStatus>
    public var stream: Stream.Continuation?
    
    func received(event: LocationBridgeEvent) {
        switch event {
        case .didChangeAuthorization(let status):
            stream?.yield(status)
        default:
            break
        }
    }
}
