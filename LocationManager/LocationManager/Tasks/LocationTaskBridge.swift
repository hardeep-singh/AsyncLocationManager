//
//  LocationTaskBridge.swift
//  LocationManager
//
//  Created by Hardeep Singh on 23/12/23.
//

import Foundation

class LocationTaskBridge {
    
    private var tasks = [String: AnyLocationTask]()
    
    private func keyForObject(task: AnyLocationTask) -> String {
        let type = type(of: task)
        return String(describing: type)
    }
    
    func add(task: AnyLocationTask) {
        self.tasks[keyForObject(task: task)] = task
    }
    
    func remove(task: AnyLocationTask.Type) {
        self.tasks.removeValue(forKey:  String(describing: task))
    }
    
    /// - Parameter event: event to dispatch.
    func dispatchEvent(event: LocationBridgeEvent) {
        for task in tasks.values {
            task.received(event: event)
        }
    }

}
