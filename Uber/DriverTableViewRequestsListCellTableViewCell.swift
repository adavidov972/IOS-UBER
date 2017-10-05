//
//  DriverTableViewRequestsListCellTableViewCell.swift
//  Uber
//
//  Created by Avi Davidov on 13/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import MapKit

class DriverTableViewRequestsListCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellBackroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblRiderName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    var distanceFromDriverToRider:CLLocationDistance = 0.0
    

    func setRequest(request:Request, driverClLocation:CLLocation) {
        
        let riderName = request.riderName
        let riderLatitude = request.riderLocation?.latitude
        let riderLongitude = request.riderLocation?.longitude

        let center = CLLocationCoordinate2D(latitude: riderLatitude!, longitude: riderLongitude!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = riderName
        mapView.addAnnotation(annotation)
        
        let riderClLocation = CLLocation(latitude: riderLatitude!, longitude: riderLongitude!)
        distanceFromDriverToRider = round(driverClLocation.distance(from: riderClLocation)/1000)
        
        lblRiderName.text = riderName
        lblDistance.text = "Rider is \(distanceFromDriverToRider) Km away from you"
    }
}
