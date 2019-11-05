//
//  ClassroomLocationViewController.swift
//  PUC Clone
//
//  Created by Tomas Martins on 24/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PuccSwift

class ClassroomLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var classToLocate: Subject?
    let locationManager = CLLocationManager()
    var center: CLLocationCoordinate2D?
    let classroomPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        if let info = classToLocate {
            super.navigationItem.title = "Prédio \(info.building?.formatTitle() ?? "")"
            if let latitudeString = info.latitude, let longitudeString = info.longitude {
                if let latitudeDouble = Double(latitudeString), let longitudeDouble = Double(longitudeString) {
                    center = CLLocationCoordinate2D.init(latitude: latitudeDouble, longitude: longitudeDouble)
                    if let mapCenter = center {
                        let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 100, longitudinalMeters: 100)
                        mapView.setRegion(region, animated: false)
                        classroomPin.coordinate = mapCenter
                        classroomPin.title = "Prédio \(info.building?.formatTitle() ?? "")"
                        mapView.addAnnotation(classroomPin)
                    }
                }
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            //do map stuff
            break
        case .denied:
            //instruct how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert that location services are restricted
            break
        default:
            break
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            //location turned off by user
        }
    }

}

extension ClassroomLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //brb
    }
}
