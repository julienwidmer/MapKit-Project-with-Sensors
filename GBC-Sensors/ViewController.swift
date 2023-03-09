//
//  ViewController.swift
//  GBC-Sensors
//
//  Created by Julien Widmer on 2023-03-09.
//

import UIKit
import CoreMotion // accelerometer and friends
import CoreLocation // GPS etc
import MapKit

class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if motionManager.isAccelerometerAvailable &&
            motionManager.isAccelerometerActive {
            print("We have access to the accelerometer.")
        } else {
            print("Accelerometer not available.")
        }
        
        print("Available: \(motionManager.isAccelerometerAvailable)")
        print("Active: \(motionManager.isAccelerometerActive)")
    }
    
    func updateMovement() {
        if let accelerometerData = motionManager.accelerometerData {
            print(accelerometerData)
        } else {
            print("No sensor / No data")
        }
    }
}

