//
//  LocationAuthorizationTask.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

class LocationAuthorizationTask: AnyLocationTask {
    
    typealias Continuation = CheckedContinuation<CLAuthorizationStatus, Error>
    private(set) var continuation: Continuation?
    
    private(set) weak var locationManager: LocationManager!
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func requestWhenInUseAuthorization() async throws -> CLAuthorizationStatus {
        try await withCheckedThrowingContinuation { continuation in
            
            let isAuthorized = locationManager.authorizationStatus != .notDetermined
            guard !isAuthorized else {
                continuation.resume(returning: locationManager.authorizationStatus)
                return
            }
            self.continuation = continuation
            locationManager.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestAlwaysAuthorization() async throws -> CLAuthorizationStatus {
        try await withCheckedThrowingContinuation { continuation in
            let isAuthorized = locationManager.authorizationStatus != .notDetermined && locationManager.authorizationStatus != .authorizedWhenInUse
            guard !isAuthorized else {
                continuation.resume(with: .success(locationManager.authorizationStatus))
                return
            }
            self.continuation = continuation
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                self.continuation?.resume(with: .success(locationManager.authorizationStatus))
                self.continuation = nil
            }
            locationManager.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func received(event: LocationBridgeEvent) {
        switch event {
        case .didChangeAuthorization(let authorization):
            guard let continuation = continuation else {
                return
            }
            continuation.resume(returning: authorization)
            self.continuation = nil
        default:
            break
        }
    }
    
}
