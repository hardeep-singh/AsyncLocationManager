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
        Task {
            do {
                try await locationManager.requestAuthorizationPermission(.always)
            }
        }
    }
}

