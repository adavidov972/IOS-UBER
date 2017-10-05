//
//  DriverNewRideViewController.swift
//  Uber
//
//  Created by Avi Davidov on 09/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase



class DriverNewRideViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var riderImage: UIImageView!
    @IBOutlet weak var lblRiderName: UILabel!
    let locationManager = CLLocationManager()
    var riderLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var request = Request()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        riderLocation = request.riderLocation!
        let coordinate = MKCoordinateRegion(center: riderLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(coordinate, animated: true)
        
        map.removeAnnotations(map.annotations)
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = riderLocation
        riderAnnotation.title = request.riderName
        map.addAnnotation(riderAnnotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        driverLocation = (manager.location?.coordinate)!
        
        map.removeAnnotations(map.annotations)
        let riderAnnotation = MKPointAnnotation()
        riderAnnotation.coordinate = riderLocation
        riderAnnotation.title = request.riderName
        map.addAnnotation(riderAnnotation)
        
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = riderLocation
        driverAnnotation.title = FirebaseController.username
        map.addAnnotation(driverAnnotation)
        
        let locations : [CLLocationCoordinate2D] = [driverLocation, riderLocation]
        let blueLine = MKPolyline(coordinates: locations, count: 2)
        map.add(blueLine)
        
    }
    
    @IBAction func btnPhoneToRider(_ sender: Any) {
        
    }
    
    
    
    
    @IBAction func btnCancelRequest(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Cancel ride", message: "Are you sure you want to cancel the ride", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
            
            FirebaseController.reference.queryOrdered(byChild: "userId").queryEqual(toValue: self.request.riderUid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                
                snapshot.ref.child("driver").removeValue()
                guard (self.navigationController?.popToRootViewController(animated: true)) != nil
                    else{
                        return
                }
            })
        }))
        
        alert.addAction (UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
