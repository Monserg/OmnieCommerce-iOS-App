
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

class Service: NSObject, NSCoding, NSCopying, InitCellParameters, SearchObject, PointAnnotationBinding, MapObjectBinding {
    // MARK: - Properties
    var codeID: String!
    var name: String!
    var organizationName: String?
    var category: Category?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var addressCity: String?
    var addressStreet: String?
    var logoURL: String?
    var headerURL: String?
    var rating: Double?
    var isFavorite: Bool = false
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServiceTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, name: String, organizationName: String?, category: Category?, rating: Double?, isFavorite: Bool, logoURL: String?, city: String?, street: String?, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        self.codeID = codeID
        self.name = name
        self.organizationName = organizationName
        self.category = category
        self.rating = rating
        self.isFavorite = isFavorite
        self.logoURL = logoURL
        self.latitude = latitude
        self.longitude = longitude
        self.addressCity = city
        self.addressStreet = street
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let organizationName = aDecoder.decodeObject(forKey: "orgName") as? String
        let category = aDecoder.decodeObject(forKey: "category") as? Category
        let rating = aDecoder.decodeObject(forKey: "rating") as? Double
        let isFavorite = aDecoder.decodeBool(forKey: "isFavorite")
        let logoURL = aDecoder.decodeObject(forKey: "logoURL") as? String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as? CLLocationDegrees
        let longitude = aDecoder.decodeObject(forKey: "longitude") as? CLLocationDegrees
        let addressCity = aDecoder.decodeObject(forKey: "addressCity") as? String
        let addressStreet = aDecoder.decodeObject(forKey: "addressStreet") as? String

        self.init(codeID: codeID, name: name, organizationName: organizationName, category: category, rating: rating, isFavorite: isFavorite, logoURL: logoURL, city: addressCity, street: addressStreet, latitude: latitude, longitude: longitude)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(organizationName, forKey: "orgName")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(isFavorite, forKey: "isFavorite")
        aCoder.encode(logoURL, forKey: "logoURL")
        aCoder.encode(addressCity, forKey: "addressCity")
        aCoder.encode(addressStreet, forKey: "addressStreet")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // Confirm MapObjectBinding Protocol
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.name = dictionary["name"] as! String
        
        if (dictionary["orgName"] as? String != nil) {
            self.organizationName = dictionary["orgName"] as? String
        }

        if (dictionary["isFavorite"] as? Bool != nil) {
            self.isFavorite = (dictionary["isFavorite"] as? Bool)!
        }
        
        if (dictionary["rating"] as? Double != nil) {
            self.rating = dictionary["rating"] as? Double
        }
        
        if (dictionary["staticUrl"] as? String != nil) {
            self.logoURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["staticUrl"] as! String)"
        }

        if (dictionary["placeId"] as? String != nil) {
            // Get Location
            let locationManager = LocationManager()
            
            locationManager.geocodingAddress(byGoogleID: (dictionary["placeId"] as? String)!, completion: { coordinate, city, street in
                self.latitude = coordinate?.latitude
                self.longitude = coordinate?.longitude
                self.addressCity = city
                self.addressStreet = street
                
                completion()
            })            
        } else {
            completion()
        }
    }
    
    // Confirm NSCopying Protocol
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Service()
        return copy
    }
}
