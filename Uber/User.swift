//
//  Rider.swift
//  Uber
//
//  Created by Avi Davidov on 03/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit

class User {
    
    var userEmail : String?
    var userUid : String?
    var userPic : UIImage?
    var userLocation : CLLocationCoordinate2D?
    

    init() {
        
    }
    
    init(userEmail:String, userUid : String, userLocation : CLLocationCoordinate2D, userPic:UIImage) {
        
        self.userEmail = userEmail
        self.userUid = userUid
        self.userLocation = userLocation
        self.userPic = userPic
    }
    
    
    
    
}
