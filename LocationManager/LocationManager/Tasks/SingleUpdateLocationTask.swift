//
//  SingleUpdateLocationTask.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

class SingleUpdateLocationTask: AnyLocationTask {
    
    weak var locationManager: LocationManager!
    
    public typealias Continuation = CheckedContinuation<CLLocation, Error>
    private var continuation: Continuation?
    var task: Task<CLLocation, Error>?
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func requestLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation {  continuation in
            self.continuation = continuation
            self.locationManager.locationManager.requestLocation()
        }
    }
    
    func received(event: LocationBridgeEvent) {
        switch event {
        case .didUpdateLocations(let locations):
            continuation?.resume(returning: locations.first!)
            continuation = nil
        case .didFailWithError(let error):
            continuation?.resume(throwing: error)
            continuation = nil
        default:
            break
        }
    }
    
}
