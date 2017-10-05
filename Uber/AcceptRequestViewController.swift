//
//  AcceptRequestViewController.swift
//  Uber
//
//  Created by Avi Davidov on 04/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptRequestViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnAcceptRequest: UIButton!
    let reference = Database.database().reference().child("uberRequests")
    let locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    var riderLocation = CLLocationCoordinate2D()
    var isdriverAcceptRequest = false
    var request = Request()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        riderLocation = request.riderLocation!
        let coordinate = MKCoordinateRegion(center: riderLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(coordinate, animated: false)
        
        map.removeAnnotations(map.annotations)
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = riderLocation
        riderAnnotation.title = request.riderName
        map.addAnnotation(riderAnnotation)
        
    }
    
    @IBAction func btnAcceptRequest(_ sender: Any) {
        
        reference.queryOrdered(byChild: "userId").queryEqual(toValue: request.riderUid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.child("driver").updateChildValues(["driverLatitude":self.driverLocation.latitude, "driverLongitude":self.driverLocation.longitude,"driverUid":FirebaseController.uid, "driverName":""])
            self.performSegue(withIdentifier: "driverRequestApprovedSegue", sender: self)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DriverNewRideViewController{
            
           destination.request = request
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        driverLocation = (manager.location?.coordinate)!
    }
}
