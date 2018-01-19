//
//  TripsManager.swift
//  Uber
//
//  Created by Avi Davidov on 17/01/2018.
//  Copyright © 2018 Avi Davidov. All rights reserved.
//

import Foundation
import MapKit
import Firebase


class TripsManager {
    
    static let manager = TripsManager()
    let driverName = FirebaseManager.manager.getFullNameFromFirebase(isDriver: true)
    let uid = FirebaseManager.manager.uid
    
    
    func updateUserLocatrion (isDriver : Bool) {
        
        let coordinate = LocationService.manager.getCoordinate()
        if isDriver {
            FirebaseManager.manager.REF_DRIVERS().child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                snapshot.ref.child("location").updateChildValues(["latitude" : coordinate.latitude, "longitude" : coordinate.longitude])
            })
        }else{
            FirebaseManager.manager.REF_RIDERS().child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                snapshot.ref.child("location").updateChildValues(["latitude" : coordinate.latitude, "longitude" : coordinate.longitude])
            })
        }
    }
    
    func stopUpdateLocation(){
        
        
        
    }
    
    func getAvalableTrips () -> [Request] {
        var tripsRequests : [Request] = []
        FirebaseManager.manager.REF_TRIPS().observe(.value, with: { (snapshot) in
            
            if let tripsDictionary = snapshot.children.allObjects as? [DataSnapshot] {
                print(tripsDictionary)
                for trip in tripsDictionary {
                    print(trip)
                    if !(trip.hasChild("driverLatitude")) {
                        
                        // AVALABLE REQUESTS
                        
                        if let tripDict = trip.value as? NSDictionary {
                            
                            guard let riderName = tripDict ["riderName"] as? String else{
                                debugPrint("Cannot get rider name from firebase")
                                return
                            }
                            
                            guard let riderLatitude = tripDict ["riderLatitude"] as? Double, let riderLongitude = tripDict ["riderLongitude"] as? Double else {
                                debugPrint("Cannot get rider location from firebase")
                                return
                            }
                            
                            let riderLocation = CLLocationCoordinate2D (latitude: riderLatitude, longitude: riderLongitude)
                            
                            guard let riderUid = tripDict ["riderUid"] as? String else {
                                debugPrint("Cannot get rider Uid from firebase")
                                return
                            }
                            let riderPhotoUrl = tripDict ["userPhotoUrl1"] as? String ?? ""
                            
                            let request = Request (riderName: riderName, driverName: self.driverName, riderLocation: riderLocation, riderImage: riderPhotoUrl, riderUid: riderUid)
                            
                            tripsRequests.append(request)
                        }
                    }
                }
            }
        })
        return tripsRequests
    }
    
    func sendTripRequest (withLocation location : CLLocationCoordinate2D) {
        let userName = FirebaseManager.manager.getFullNameFromFirebase(isDriver: false)
        let tripDictionary : [String:Any] = [
            "riderLatitude" : location.latitude,
            "riderLongitude" : location.longitude,
            "riderName" : userName,
            "riderUid" : uid]
        
        FirebaseManager.manager.REF_TRIPS().child(uid).setValue(tripDictionary)
    }
}
