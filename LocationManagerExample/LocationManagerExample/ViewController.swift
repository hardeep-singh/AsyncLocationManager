//
//  ViewController.swift
//  LocationManagerExample
//
//  Created by Hardeep Singh on 23/12/23.
//

import UIKit
import AsyncLocationManager

class ViewController: UIViewController {

    var locationManager = LocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Authorized:- \(locationManager.isAuthorized)")
        print("AuthorizationStatus:- \(locationManager.authorizationStatus)")

        Task {
            print("Location Services Enabled:- \(await locationManager.locationServicesEnabled)")
        }
        
    }
    
    @IBAction func requestAuthorizationPermission(_ sender: Any) {
        Task {
            do {
                let authorizationStatus = try await locationManager.requestAuthorizationPermission(.always)
                print(authorizationStatus)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func requestASingleLocation(_ sender: Any) {
        Task {
            do {
                let location = try await locationManager.requestLocation()
                print(location)
            }
        }
    }
    
    
    @IBAction func startMonitoringAndUpdatingLocation(_ sender: Any) {
        
        Task {
            for await location in  await locationManager.startUpdatingLocation() {
                switch location {
                case .didFailWithError(let error):
                    print("Location:- \(error)")
                case .didPaused:
                    print("Location Did Paused")
                    break
                case .didResume:
                    print("Location Did Resume")
                    break
                case .didUpdateLocations(let locations):
                    print("Location Did Update:- \(locations)")
                    break
                }
            }
        }
        
    }
    
}



