//
//  LocationManager.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 11.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationManager: BaseViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager?
    var handlerLocationCompletion: HandlerLocationCompletion?
    var organizations: [Organization]!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Functions
    func startCoreLocation(withOrganizations organizations: [Organization]) {
        self.organizations          =   organizations
        
        locationManager             =   CLLocationManager()
        locationManager!.delegate   =   self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager!.requestLocation()
        }
    }
    
    func stopCoreLocation() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var organizationsPlacemarks = [CLPlacemark]()
        
        // Geocoding organizations locations
        for organization in organizations {
            let location = CLLocation.init(latitude: organization.location.latitude, longitude: organization.location.longitude)

            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard placemarks != nil else {
                    return
                }
                
                let placemark = placemarks![0]
                
                organizationsPlacemarks.append(placemark)
            }
        }

        self.handlerLocationCompletion!(organizationsPlacemarks)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertViewDidShow(withTitle: "Error".localized(), andMessage: error.localizedDescription)
    }
    
    // Check Authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedAlways || status != .authorizedWhenInUse) {
            alertViewDidShow(withTitle: "Info".localized(), andMessage: "Location authorization error".localized())
        }
    }
}
