//
//  FirebaseController.swift
//  Uber
//
//  Created by Avi Davidov on 11/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class FirebaseController: NSObject {
    
    static let shared = FirebaseController()
    static let reference = Database.database().reference().child("uberRequests")
    static let uid : String = (Auth.auth().currentUser?.uid)!
    static let username = Auth.auth().currentUser?.email

    func getSnap() {
       
        
        
    }

}
