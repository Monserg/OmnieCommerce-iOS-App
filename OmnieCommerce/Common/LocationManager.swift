//
//  LocationManager.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 11.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import CoreLocation
import Contacts

enum LocationMode {
    case Standard
    case Current
}

class LocationManager: BaseViewController {
    // MARK: - Properties
    private var locationManager: CLLocationManager?
    var organizations: [Organization]!
    var mode: LocationMode = .Standard
    
    var currentLocation: LocationItem! {
        didSet {
            if (mode == .Current) {
                self.stopCoreLocation()
            }
            
            self.handlerPassCurrentLocationCompletion!(currentLocation)
        }
    }
    
    var handlerLocationCompletion: HandlerLocationCompletion?
    var handlerPassCurrentLocationCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func startCoreLocation(inMode mode: LocationMode) {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = 10.0
            locationManager!.requestLocation()
        }
    }
    
    func startCoreLocation(withOrganizations organizations: [Organization]) {
        self.organizations = organizations
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = 10.0
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
            let location = CLLocation.init(latitude: (organization.latitude)!, longitude: (organization.longitude)!)
            let item = organization
            
            self.print(object: "organization: \(organization.name) before: \(location)")

            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard placemarks != nil else {
                    return
                }
                
                let placemark = placemarks![0]
                self.print(object: "organization: \(organization.name) after: \(location) placemark: \(placemark)")

                if (item.name == "Organization 0") {
                    self.print(object: placemark)
                }
                
                item.addressCity = placemark.locality
                let street = placemark.thoroughfare ?? ""
                let house = placemark.subThoroughfare ?? ""
                
                if (!street.isEmpty) {
                    if (house.isEmpty) {
                        item.addressStreet = "\(street)"
                    } else {
                        item.addressStreet = "\(street), \(house)"
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
    
    func geocodingAddress(string address: String, completion: @escaping ((_ coordinate: CLLocationCoordinate2D?, _ city: String?, _ street: String?) -> ())) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            guard error == nil else {
                return completion(nil, nil, nil)
            }
            
            let placemark = placemarks!.first!
            let coordinate = placemark.location!.coordinate
            let city = placemark.locality
            var street = placemark.thoroughfare ?? ""
            let house = placemark.subThoroughfare ?? ""
            
            if (!street.isEmpty) {
                if (house.isEmpty) {
                    street = "\(street)"
                } else {
                    street = "\(street), \(house)"
                }
            }

            return completion(coordinate, city, street)
        })
    }
    
    func geocodingAddress(byGoogleID placeID: String, completion: @escaping ((_ coordinate: CLLocationCoordinate2D?, _ city: String?, _ street: String?) -> ())) {
        GMSPlacesClient().lookUpPlaceID(placeID, callback: { (place, error) in
            if (error != nil) {
                return completion(nil, nil, nil)
            }
            
            if let place = place {
                let coordinate = place.coordinate
                let components = place.addressComponents
                let city = (components!.first(where: { $0.type == "locality" })! as GMSAddressComponent).name
                let street = place.name

                return completion(coordinate, city, street)
            } else {
                return completion(nil, nil, nil)
            }
        })
    }
    
    func coordinatesConvertToAddress(_ coordinates: CLLocationCoordinate2D, completion: @escaping (() -> ())) {
        let location = CLLocation.init(latitude: coordinates.latitude, longitude: coordinates.longitude)

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard placemarks != nil else {
                return
            }
            
            let placemark = placemarks![0]
            
            if let dictionary = placemark.addressDictionary, dictionary.count > 0 {
                self.currentLocation.addressCity = dictionary["City"] as? String
                self.currentLocation.addressStreet = dictionary["Thoroughfare"] as? String
            }

            return completion()
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.first != nil) {
            CLGeocoder().reverseGeocodeLocation(locations[0] as CLLocation) { (placemarks, error) in
                if (error != nil) {
                    self.print(object: "Error getting location: \(error!.localizedDescription)")
                } else {
                    if let placeMark = (placemarks as [CLPlacemark]!).first, (placeMark.addressDictionary?.count)! > 0 {
                        self.currentLocation = LocationItem(cellIdentifier: "",
                                                            cellHeight: 0.0,
                                                            name: "Zorro",
                                                            latitude: (locations[0] as CLLocation).coordinate.latitude,
                                                            longitude: (locations[0] as CLLocation).coordinate.longitude,
                                                            addressCity: placeMark.addressDictionary!["City"] as? String,
                                                            addressStreet: placeMark.addressDictionary!["Thoroughfare"] as? String)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertViewDidShow(withTitle: "Error", andMessage: error.localizedDescription, completion: { _ in })
    }
    
    // Check Authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedAlways || status != .authorizedWhenInUse) {
            alertViewDidShow(withTitle: "Info", andMessage: "Location authorization error", completion: { _ in })
        }
    }
}
