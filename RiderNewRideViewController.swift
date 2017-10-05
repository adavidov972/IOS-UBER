//
//  RiderNewRideViewController.swift
//
//
//  Created by Avi Davidov on 09/09/2017.
//
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class RiderNewRideViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDriverOnTheWay: UILabel!
    @IBOutlet weak var map: MKMapView!
    var request = NSDictionary()
    var snapshot = DataSnapshot()
    var driverLocation = CLLocationCoordinate2D()
    var riderLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    let Uid = FirebaseController.uid
    let reference = FirebaseController.reference
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        navigationController?.title = "Driver is on the way"
        let center = riderLocation
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)

        
    }
    
    func addRiderDriverAnnotastions(driverLocation:CLLocationCoordinate2D) {
        map.removeAnnotations(map.annotations)
        
        let riderAnnotation = MKPointAnnotation ()
        riderAnnotation.coordinate = CLLocationCoordinate2D(latitude: riderLocation.latitude, longitude: riderLocation.longitude)
        map.addAnnotation(riderAnnotation)
        
        let driverAnnotation = MKPointAnnotation ()
        driverAnnotation.coordinate = CLLocationCoordinate2D(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        map.addAnnotation(driverAnnotation)
    }
    
    func distanceCalculate(driverLocation:CLLocation, riderLocation:CLLocation) {
        
        let doubleDistance = driverLocation.distance(from: riderLocation)/1000
        let distance = round(doubleDistance * 100)/100
        lblDistance.text = "Your driver is \(distance) Km away"
        
        print(distance)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = manager.location?.coordinate
        riderLocation = coordinate!
        print("rider location \(riderLocation)")
        
        if let Uid = request ["userId"] {
            reference.queryOrdered(byChild: "userId").queryEqual(toValue: Uid).observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                
                guard   let requestDictionary = snapshot.value as? NSDictionary,
                    let driverLat = requestDictionary ["driverLat"] as? Double,
                    let driverLong = requestDictionary ["driverLong"] as? Double
                    else{
                        return
                }
                
                let riderClLocation = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
                let driverClLocation = CLLocation(latitude: driverLat, longitude: driverLong)
                self.distanceCalculate(driverLocation: driverClLocation, riderLocation: riderClLocation)
                snapshot.ref.updateChildValues(["latitude":self.riderLocation.latitude, "longitude":self.riderLocation.longitude])
            })
            
            addRiderDriverAnnotastions(driverLocation: driverLocation)
        }
    }
}
