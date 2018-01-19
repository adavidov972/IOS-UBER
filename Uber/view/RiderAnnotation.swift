//
//  RiderAnnotation.swift
//  Uber
//
//  Created by Avi Davidov on 17/01/2018.
//  Copyright © 2018 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit

class RiderAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    
    init(coordinate : CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init ()
    }
    
    func addAnnotation () {
        
        
        
    }

}
