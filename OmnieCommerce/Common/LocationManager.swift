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
import Contacts

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
    
    deinit {
        print(object: "\(self.className) deinit")
    }
    
    
    // MARK: - Custom Functions
    func startCoreLocation(withOrganizations organizations: [Organization]) {
        self.organizations          =   organizations
        
        locationManager             =   CLLocationManager()
        locationManager!.delegate   =   self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy    =   kCLLocationAccuracyBest
            locationManager!.distanceFilter     =   10.0
            locationManager!.requestLocation()
        }
    }
    
    func stopCoreLocation() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func organizationsDidModify() {
        var items = [Organization]()
        
        // Geocoding organizations locations
        for organization in organizations {
            let location    =   CLLocation.init(latitude: organization.location.latitude, longitude: organization.location.longitude)
            var item        =   organization
            
            self.print(object: "organization: \(organization.name) before: \(location)")

            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard placemarks != nil else {
                    return
                }
                
                let placemark               =   placemarks![0]
                self.print(object: "organization: \(organization.name) after: \(location) placemark: \(placemark)")

                if (item.name == "Organization 0") {
                    self.print(object: placemark)
                }
                
                item.addressCity            =   placemark.locality
                let street                  =   placemark.thoroughfare ?? ""
                let house                   =   placemark.subThoroughfare ?? ""
                
                if (!street.isEmpty) {
                    if (house.isEmpty) {
                        item.addressStreet  =   "\(street)"
                    } else {
                        item.addressStreet  =   "\(street), \(house)"
                    }
                }
                
                items.append(item)
                
                if (items.count == self.organizations.count) {
                    self.stopCoreLocation()
                    
                    self.handlerLocationCompletion!(items)
                }
            }
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
