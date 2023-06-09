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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    let motionManager = CMMotionManager()
    var timer: Timer!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Location
        // Set delegate
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        // Get every update
        locationManager.startUpdatingLocation()
        
        // Get significant location update only
        //locationManager.startMonitoringSignificantLocationChanges()
        
        // MARK: Requires extra listener method
        locationManager.startMonitoringVisits()
        
       // Display user current location with a blue dot on the map
       //mapView.showsUserLocation = true
        
        // MARK: - Accelerometer (Timer has been commented out)
        if motionManager.isAccelerometerAvailable &&
            motionManager.isAccelerometerActive {
            print("We have access to the accelerometer.")
        } else {
            print("Accelerometer not available.")
        }
        
        print("Available: \(motionManager.isAccelerometerAvailable)")
        print("Active: \(motionManager.isAccelerometerActive)")
        
        // Repeat every 3sec
        /*
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true,
                                     block: updateMovement)
         */
    }
    
    func updateMovement(_ timer: Timer) {
        if let accelerometerData = motionManager.accelerometerData {
            print(accelerometerData)
        } else {
            print("No sensor / No data")
        }
    }
    
    var pin: MKPlacemark!
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // Unwrap value or return if none
        guard let location = locations.last else { return }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let places = places {
                for place in places {
                    print("Name: \(place.name ?? "N/A"), Description: \(place.description)")
                }
            }
        })
        
        // MARK: - Map View
        // Center our position on the map
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             latitudinalMeters: 1000,
        longitudinalMeters: 1000), animated: true)
        
        
        // Create MKPlacemark
        pin = MKPlacemark(coordinate: location.coordinate)
        
        // Remove previous pin
        if pin != nil {
            mapView.removeAnnotation(pin)
        }
        
        // Add pin on map
        mapView.addAnnotation(pin)
        
        //print(location)
    }
    
    // MARK: - Required for locationManager.startMonitoringVisits()
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("--- DID VISIT ---")
        print("Description: \(visit.description)")
    }
}

