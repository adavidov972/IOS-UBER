//
//  FlowController.swift
//  Uber
//
//  Created by Avi Davidov on 03/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import Firebase

class FlowController: NSObject {
    
    static let shared = FlowController()
    
    weak var window : UIWindow?
    
    func determineRoot(){
        
        guard let currentUser = Auth.auth().currentUser, let name = currentUser.displayName else{
            display(storyboard: "Login")
            return
        }
        print(currentUser.description)
        display(storyboard: name)
    }
    
    private func display(storyboard name : String){
        let storyboard = UIStoryboard(name: name, bundle: .main)
        let rootViewController = storyboard.instantiateInitialViewController()
        
        window?.rootViewController = rootViewController
    }
    
}
