//
//  LocationManagerTests.swift
//  LocationManagerTests
//
//  Created by Hardeep Singh on 23/12/23.
//

import XCTest
@testable import LocationManager
import CoreLocation

final class LocationManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_authorized_deliversWhenInUsePermissionOnRequestWhenInUse() {
        let client = LocationManagerSpy()
        let sut = LocationManager(locationManager: client)
        
        let excpet: CLAuthorizationStatus = .authorizedWhenInUse
        
        let exp = expectation(description: "Check Authorization")
        
        Task {
            do {
                let result =  try await sut.requestAuthorizationPermission(.whenInUse)
                XCTAssertEqual(result, excpet)
            } catch {
                XCTFail("\(error)")
            }
            exp.fulfill()
        }
            
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_authorized_deliversAlwaysPermissionOnRequestAlways() {
        let client = LocationManagerSpy()
        let sut = LocationManager(locationManager: client)
        
        let excpet: CLAuthorizationStatus = .authorizedAlways
        
        let exp = expectation(description: "Check Authorization")
        
        Task {
            do {
                let result =  try await sut.requestAuthorizationPermission(.always)
                XCTAssertEqual(result, excpet)
            } catch {
                XCTFail("\(error)")
            }
            exp.fulfill()
        }
            
        wait(for: [exp], timeout: 1.0)
    }
    
    private class LocationManagerSpy: CLLocationManager {
        
        var messageAuthorizationStatus: CLAuthorizationStatus = .notDetermined
        
        override var authorizationStatus: CLAuthorizationStatus {
            return messageAuthorizationStatus
        }
        
        override func requestAlwaysAuthorization() {
            messageAuthorizationStatus = .authorizedAlways
            self.delegate?.locationManager?(self, didChangeAuthorization: messageAuthorizationStatus)
            self.delegate?.locationManagerDidChangeAuthorization?(self)
        }
        
        override func requestWhenInUseAuthorization() {
            messageAuthorizationStatus = .authorizedWhenInUse
            self.delegate?.locationManager?(self, didChangeAuthorization: messageAuthorizationStatus)
            self.delegate?.locationManagerDidChangeAuthorization?(self)
        }
                
    }

}
