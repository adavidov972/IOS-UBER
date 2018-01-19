//
//  SignUpViewController.swift
//  Uber
//
//  Created by Avi Davidov on 21/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import libPhoneNumber_iOS
import CoreData


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhoneNumber: ToolbarTextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var riderDriverSegmented: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func viewTapped() {
        
        txtPhoneNumber.endEditing(true)
        txtEmail.endEditing(true)
        txtFullName.endEditing(true)
        txtPassword.endEditing(true)
    }
    
    func makeSignup() {
        
        SVProgressHUD.show()
        let isdriver = self.riderDriverSegmented.selectedSegmentIndex != 0
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
            
            if error != nil{
                self.displayAlert(title: "Sign up error", message: error!.localizedDescription)
                SVProgressHUD.dismiss()
                
            }else{
                
                let request = user?.createProfileChangeRequest()
                if isdriver {
                    
                    //DRIVER
                    request?.displayName = "Driver"
                    
                }else{
                    
                    //RIDER
                    request!.displayName = "Rider"
                }
                
                request?.commitChanges(completion: { (err) in
                    FlowController.shared.determineRoot()
                })
                
                let userInfo : [String:Any] = [
                    "fullName": self.txtFullName.text!,
                    "PhoneNumber":self.txtPhoneNumber.text!,
                    "FCMToken" : Messaging.messaging().fcmToken!,
                    "email" : self.txtEmail.text!,
                    "isDriver" : isdriver]
                
                FirebaseManager.manager.createFirebaseDBUser(userinfo: userInfo)
                SVProgressHUD.dismiss()
            }
        })
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        if txtEmail.text == "" || txtPassword.text == "" {
            displayAlert(title: "Missing information", message: "Please enter Email and password correctly")
        }else{
            if LibPhoneCheckManager.manager.isPhoneNumberValid(phoneStr: txtPhoneNumber.text!) {
              makeSignup()
            }else {
                displayAlert(title: "Phone number is incorrect", message: "Please enter valid phone number")
            }
        }
    }
    
    func displayAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnBackToLogin(_ sender: Any)  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidEndOnExitAction(_ sender: Any) {
        makeSignup()
    }

    @IBAction func txtPhoneChange(_ sender: UITextField) {
        
        if sender.text?.count == 11 {
            sender.endEditing(true)
        }
    }

}
