//
//  AnyLocationTask.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation

protocol AnyLocationTask {
    func received(event: LocationBridgeEvent)
}
