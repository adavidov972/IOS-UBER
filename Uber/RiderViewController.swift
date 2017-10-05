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

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnCallOrCancelUber: UIButton!
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberCalled = false
    let reference = Database.database().reference().child("uberRequests")
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let Uid = currentUser?.uid{
            
            reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                
                self.uberCalled = true
                self.btnCallOrCancelUber.setTitle("Cancel Uber", for: .normal)
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
            mapView.addAnnotation(annotation)
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
                uberCalled = false
                
            }else{
                
                //REQUEST MODE
                
                if let userEmail = currentUser?.email{
                    
                    let newRequestDictionary : [String:Any] = ["userId":Uid,"latitude":userLocation.latitude,"longitude":userLocation.longitude,"email":userEmail]
                    
                    reference.childByAutoId().setValue(newRequestDictionary)
                    reference.removeAllObservers()
                    btnCallOrCancelUber.setTitle("Cancel Uber", for: .normal)
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
    
    @IBAction func btnLogout(_ sender: Any) {
        
        try? Auth.auth().signOut()
        FlowController.shared.determineRoot()
    }
}







