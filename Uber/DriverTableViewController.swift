//
//  DriverTableViewController.swift
//  Uber
//
//  Created by Avi Davidov on 03/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class DriverTableViewController: UITableViewController,CLLocationManagerDelegate {
    
    var ridersRequests : [Request] = []
    let locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    let reference = Database.database().reference().child("uberRequests")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        tableView.backgroundView = UIImageView(image: (UIImage(named:"backround")))
        
        reference.queryOrdered(byChild: "driverUid").queryEqual(toValue: FirebaseController.uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
               
                self.performSegue(withIdentifier: "tableViewToRideSegue", sender: self.requestWithsnap(snapshot: snapshot))
        })
        
        reference.observe(.childAdded, with: { (snapshot) in
            
            if let snapToDictionary = snapshot.value as? NSDictionary {
                
                if let driverLat = snapToDictionary ["driverLatitude"] {
                    print(driverLat)
                    
                }else{
                    
                    //NO DRIVER ACCEPTED THE REQUEST
                    
                    self.ridersRequests.append(self.requestWithsnap(snapshot: snapshot))
                    print("First snapshot is :\(snapshot)")
                    self.tableView.reloadData()
                }
            }
        })
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ridersRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> DriverTableViewRequestsListCellTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DriverTableViewRequestsListCellTableViewCell
        let request = ridersRequests [indexPath.row]
        cell.setRequest(request: request, driverClLocation: CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude))
        
//        if indexPath.row%2 == 0 {
//            cell.backgroundColor = UIColor .groupTableViewBackground
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let request = ridersRequests [indexPath.row]
        performSegue(withIdentifier: "acceptRequestSegue", sender: request)
        self.reference.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "acceptRequestSegue" {
            
            if let acceptViewController = segue.destination as? AcceptRequestViewController{
                acceptViewController.request = sender as! Request
            }
        }else {
            
            if let newRideViewController = segue.destination as? DriverNewRideViewController{
                newRideViewController.request = sender as! Request
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        driverLocation = (locationManager.location?.coordinate)!
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        try? Auth.auth().signOut()
        FlowController.shared.determineRoot()
    }
    
    func requestWithsnap(snapshot:DataSnapshot) -> Request {
       
        var request = Request()
        let snapToDictionary = snapshot.value as? NSDictionary
        guard let email = snapToDictionary? ["email"] as? String, let riderLatitude = snapToDictionary? ["latitude"], let riderLogitude = snapToDictionary?["longitude"], let riderUid = snapToDictionary? ["userId"] else {
            return request
        }
        let riderLocation = CLLocationCoordinate2D(latitude: riderLatitude as! CLLocationDegrees, longitude: riderLogitude as! CLLocationDegrees)
        
        request = (Request(riderName: email, driverName: FirebaseController.username!, riderLocation: riderLocation, riderImage: "", riderUid: riderUid as! String))
        
        return request

    }
}
