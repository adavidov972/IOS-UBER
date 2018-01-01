//
//  RiderViewController.swift
//  Uber
//
//  Created by Avi Davidov on 02/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var sideBarLeftConstrain: NSLayoutConstraint!
    @IBOutlet weak var lblSearchingForUber: UILabel!
    @IBOutlet weak var sideBaeMenu: UIView!
    @IBOutlet weak var btnUserImage: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnCallOrCancelUber: UIButton!
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberCalled = false
    let reference = Database.database().reference().child("uberRequests")
    let currentUser = Auth.auth().currentUser
    var user = User()
    let imagePicker = UIImagePickerController()
    var sideBarOpen = false
    var timer = Timer()
    var lblSearchCounter = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        lblSearchingForUber.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let Uid = currentUser?.uid{
            
            reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                
                self.uberCalled = true
                self.btnCallOrCancelUber.setTitle("Cancel Uber", for: .normal)
                self.lblSearchingForUber.isHidden = false
                self.timer = Timer.scheduledTimer (timeInterval: 1.0, target: self, selector: #selector (RiderViewController.animate), userInfo: nil, repeats: true)
                print(snapshot)
            })
            
            reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                if let riderRequestDictionary = snapshot.value as? NSDictionary {
                    if riderRequestDictionary["driverLat"] != nil {
                        
                        //MEANS SOME DRIVER APPROVED THE REQUEST
                        
                        self.performSegue(withIdentifier: "riderRequestApprovedSegue", sender: riderRequestDictionary)
                        self.reference.child(Uid).removeAllObservers()
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = locationManager.location?.coordinate{
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Me"
            UIView.animate(withDuration: 0.8, animations: {
                self.mapView.addAnnotation(annotation)
            })
            
        }
    }
    
    @IBAction func btnCallOrCancelUber(_ sender: Any) {
        
        if let Uid = currentUser?.uid {
            
            if uberCalled {
                
                //CANCELING MODE
                
                reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observe(.childAdded, with: { (snapShot) in
                    
                    snapShot.ref.removeValue()
                    self.reference.child(Uid).removeAllObservers()
                })
                btnCallOrCancelUber.setTitle("Call an Uber", for: .normal)
                lblSearchingForUber.isHidden = true
                uberCalled = false
                timer.invalidate()
                
            }else{
                
                //REQUEST MODE
                
                if let userEmail = currentUser?.email{
                    
                    let newRequestDictionary : [String:Any] = ["userId":Uid,"latitude":userLocation.latitude,"longitude":userLocation.longitude,"email":userEmail]
                    
                    reference.childByAutoId().setValue(newRequestDictionary)
                    reference.removeAllObservers()
                    btnCallOrCancelUber.setTitle("Cancel Uber", for: .normal)
                    lblSearchingForUber.isHidden = false
                    timer.invalidate()
                    timer = Timer.scheduledTimer (timeInterval: 1.0, target: self, selector: #selector (RiderViewController.animate), userInfo: nil, repeats: true)
                    uberCalled = true
                    
                    reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observe(.childChanged, with: { (snapshot) in
                        if let riderRequestDictionary = snapshot.value as? [String:AnyObject?]{
                            print(snapshot)
                            
                            if riderRequestDictionary["driverLat"] != nil {
                                
                                //MEANS SOME DRIVER APPROVED THE REQUEST
                                
                                self.performSegue(withIdentifier: "riderRequestApprovedSegue", sender: riderRequestDictionary)
                                self.reference.removeAllObservers()
                                
                            }else{
                                
                                //NO ONE APPROVED THE REQUEST YET
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? RiderNewRideViewController {
            if let request = sender as? NSDictionary {
                destination.request = request
            }
        }
    }
    
    @objc func animate() {
        let text = ["", "Searching for UBER  ......"]
        
        lblSearchingForUber.text = text[lblSearchCounter]
        lblSearchCounter+=1

        if lblSearchCounter == 2 {
            lblSearchCounter = 0
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        
        try? Auth.auth().signOut()
        FlowController.shared.determineRoot()
    }
    
    @IBAction func addOrChageUserPhoto(_ sender: UIButton) {
        
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Pick image source", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Open camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Pick from library", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info [UIImagePickerControllerOriginalImage] as? UIImage{
            
            user.userPic = imagePicked
            btnUserImage.setImage(imagePicked, for: .normal)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCloseSideBar(_ sender: UIBarButtonItem) {
        
        if sideBarOpen {
            
            //The side bar is open
            
            sideBarLeftConstrain.constant = -170
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            btnCallOrCancelUber.isEnabled = true

        }else{
            
            //The sidebar is close
            sideBarLeftConstrain.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            btnCallOrCancelUber.isEnabled = false


        }
        sideBarOpen = !sideBarOpen
    }
    
    @IBAction func viewGestureTapped(_ sender: Any) {
        
        if sideBarOpen {
            
            //The side bar is open
            
            sideBarLeftConstrain.constant = -170
            btnCallOrCancelUber.isEnabled = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            sideBarOpen = !sideBarOpen
        }
    }
}






