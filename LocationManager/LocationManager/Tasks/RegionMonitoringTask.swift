//
//  RegionMonitoringTask.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

public class RegionMonitoringTask: AnyLocationTask {
    
    /// The event produced by the stream.
    public typealias Stream = AsyncStream<RegionStreamResult>
    public var stream: Stream.Continuation?
    
    /// The event produced by the stream.
    public enum RegionStreamResult {
        case didEnterTo(region: CLRegion)
        case didExitTo(region: CLRegion)
        case didStartMonitoringFor(region: CLRegion)
        case monitoringDidFailFor(region: CLRegion?, error: Error)
    }
    
    func received(event: LocationBridgeEvent) {
        switch event {
        case let .didStartMonitoringFor(region):
            stream?.yield(.didStartMonitoringFor(region: region))
            
        case let .didEnterRegion(region):
            stream?.yield(.didEnterTo(region: region))
            
        case let .didExitRegion(region):
            stream?.yield(.didExitTo(region: region))
            
        case let .monitoringDidFailFor(region, error):
            stream?.yield(.monitoringDidFailFor(region: region, error: error))
            
        default:
            break
        }
    }
   
}
