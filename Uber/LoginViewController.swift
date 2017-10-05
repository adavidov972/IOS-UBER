//
//  LoginViewController.swift
//  Uber
//
//  Created by Avi Davidov on 01/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import Firebase


//to fix after signup screen return to log in and not going to flowController


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblSwitchSignupLogin: UILabel!
    var isLoginMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
    }
    
    
    func displayAlert(title:String,message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        if txtEmail.text == "" || txtPassword.text == "" {
            displayAlert(title: "Missing information", message: "Please enter Email and password correctly")
        }else{
            makeLogin(email: txtEmail.text!, password: txtPassword.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.lengthOfBytes(using: .utf8))! > 3) {
            textField.returnKeyType = .go
            
        }else{
            textField.returnKeyType = .default
        }
        
        textField.reloadInputViews()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        makeLogin(email: txtEmail.text!, password: txtPassword.text!)
        return true
    }
    
    func makeLogin (email:String, password:String) {
        
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                self.displayAlert(title: "Log in error", message: error!.localizedDescription)
                SVProgressHUD.dismiss()
                
            }else{
                SVProgressHUD.dismiss()
                Database.database().reference().child("usersDetails").child((Auth.auth().currentUser?.uid)!).updateChildValues(["FCMToken" : Messaging.messaging().fcmToken!])
                FlowController.shared.determineRoot()
            }
        })
    }
}
