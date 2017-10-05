//
//  Request.swift
//  Uber
//
//  Created by Avi Davidov on 14/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit

class Request: NSObject {
    
    var riderName:String?
    var driverName:String?
    var riderLocation:CLLocationCoordinate2D?
    var riderImage:String?
    var riderUid:String?
    
    init(riderName:String, driverName:String, riderLocation:CLLocationCoordinate2D,riderImage:String,riderUid:String) {
        
        self.riderName = riderName
        self.driverName = driverName
        self.riderLocation = riderLocation
        self.riderImage = riderImage
        self.riderUid = riderUid
    }
    
    override init() {
        
    }
}
