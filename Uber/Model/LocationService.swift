//
//  LocationService.swift
//  Uber
//
//  Created by Avi Davidov on 19/01/2018.
//  Copyright © 2018 Avi Davidov. All rights reserved.
//

import Foundation
import MapKit

class LocationService : NSObject, CLLocationManagerDelegate {
    
    static let manager = LocationService()
    private let locationManager = CLLocationManager()
    private var location = CLLocation()
    private var coordinate = CLLocationCoordinate2D ()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func getLocation () -> CLLocation {
        
        return location
    }
    
    
    func getCoordinate () -> CLLocationCoordinate2D {
        
        return coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse, .authorizedAlways:
            guard let location = locationManager.location, let coordinate = locationManager.location?.coordinate else {
                debugPrint("Cannot get location")
                return
            }
            self.location = location
            self.coordinate = coordinate
            
        case .denied, .notDetermined, .restricted :
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
