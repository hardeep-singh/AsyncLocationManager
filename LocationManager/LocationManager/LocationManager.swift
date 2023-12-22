//
//  LocationManager.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation
import CoreLocation

public class LocationManager {
    
    private(set) var locationManager: CLLocationManager
    private(set) var locationDelegate: LocationDelegate
    private(set) var locationTaskBridge: LocationTaskBridge = .init()
    
    public init() {
        locationManager = CLLocationManager()
        locationDelegate = LocationDelegate(locationTaskBridge: locationTaskBridge)
        locationManager.delegate = locationDelegate
    }
    
    /// The status of your app’s authorization to provide parental controls.
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
           return locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            return CLLocationManager.authorizationStatus()
        }
    }
    
    /// Indicates the level of location accuracy the app has permission to use.
    public var locationServicesEnabled: Bool {
        get async {
            await Task.detached {
                CLLocationManager.locationServicesEnabled()
            }.value
        }
    }
    
    public var isAuthorized: Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    // MARK: - Request permissions
    @discardableResult
    public func requestAuthorizationPermission(_ permission: LocationPermissionType) async throws -> CLAuthorizationStatus {
        switch permission {
        case .whenInUse:
            return try await requestWhenInUseAuthorization()
        case .always:
            return try await requestAlwaysAuthorization()
        }
    }
    
    private func requestWhenInUseAuthorization() async throws -> CLAuthorizationStatus {
        let task = LocationAuthorizationTask(locationManager: self)
        locationTaskBridge.add(task: task)
        return try await task.requestWhenInUseAuthorization()
    }
    
    private func requestAlwaysAuthorization() async throws -> CLAuthorizationStatus {
        let locationPermission = LocationAuthorizationTask(locationManager: self)
        locationTaskBridge.add(task: locationPermission)
        return try await locationPermission.requestAlwaysAuthorization()
    }
    
    // MARK: -
    @discardableResult
    public func requestLocation() async throws -> CLLocation {
        let singleLocation = SingleUpdateLocationTask(locationManager: self)
        locationTaskBridge.add(task: singleLocation)
        return try await singleLocation.requestLocation()
    }
    
}
