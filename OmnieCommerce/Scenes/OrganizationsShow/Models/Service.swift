
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

class ServiceOld: NSObject, NSCoding, InitCellParameters, SearchObject, PointAnnotationBinding {
    // MARK: - Properties
    var category: Category?
    var needBackgroundColorSet: Bool = false
    var isNameNeedHide: Bool = false
    var isCommonProfile: Bool = true

    // From common API response
    var codeID: String!
    var organizationName: String?
    var logoURL: String?
    var headerURL: String?
    var rating: Double?
    var isFavorite: Bool = false
    
    // Confirm SearchObject Protocol
    var name: String!

    // Confirm PointAnnotationBinding Protocol
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var addressCity: String?
    var addressStreet: String?

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServiceTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    // From full API response
    var prices: [ServicePrice]?
    
    
    
    
    
    // MARK: - Class Initialization
    init(withCommonProfile isCommonProfile: Bool) {
        super.init()
        
        self.isCommonProfile = isCommonProfile
    }
        
    init(codeID: String, name: String, organizationName: String?, category: Category?, rating: Double?, isFavorite: Bool, logoURL: String?, city: String?, street: String?, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, prices: [ServicePrice]?) {
        // Common profile
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
        
        // Full profile
        self.prices = prices
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        // Common profile
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
        
        // Full profile
        let prices = aDecoder.decodeObject(forKey: "prices") as? [ServicePrice]

        self.init(codeID: codeID, name: name, organizationName: organizationName, category: category, rating: rating, isFavorite: isFavorite, logoURL: logoURL, city: addressCity, street: addressStreet, latitude: latitude, longitude: longitude, prices: prices)
    }
    
    func encode(with aCoder: NSCoder) {
        // Common profile
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
        
        // Full profile
        aCoder.encode(prices, forKey: "prices")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension ServiceOld: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        // Common profile
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

        // Full profile
        if (!isCommonProfile) {
            if let priceItems = dictionary["servicePrices"] as? NSArray {
                var items = [ServicePrice]()
                
                for dictionary in priceItems {
                    let price = ServicePrice()
                    price.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(price)
                }
                
                self.prices = items
            }
        }
        
        // Position from Common profile
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
}


//// MARK: - NSCopying
//extension ServiceOld: NSCopying {
//    func copy(with zone: NSZone? = nil) -> Any {
////        let copy = Service.init(withCommonProfile: self.isCommonProfile)
////        return copy
//    }
//}
