//
//  LocationDetector.swift
//  Metro Explorer
//
//  Created by hct0704 on 12/3/18.
//  Copyright © 2018 hct0704. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDetectorDelegate{
    func locationDetected(latitude: Double, longitude: Double)//location detected
    func locationNotDetected()//for no signal or no permission or time out
    
}

class LocationDetector: NSObject{
    let locationManager = CLLocationManager()
    var delegate: LocationDetectorDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func findLocation(){
        let permissionStatus = CLLocationManager.authorizationStatus()
        
        switch(permissionStatus) {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            delegate?.locationNotDetected()
        case .denied:
            delegate?.locationNotDetected()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        }
    }
}

extension LocationDetector: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something with the location
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            delegate?.locationDetected(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //handle the error
        print(error.localizedDescription)
        delegate?.locationNotDetected()
    }
    
    //this gets called after user accepts OR denies permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //handle this
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else {
            delegate?.locationNotDetected()
        }
    }
    
}
