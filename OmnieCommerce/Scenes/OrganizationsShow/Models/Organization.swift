
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

class Organization: NSObject, NSCoding, InitCellParameters, SearchObject {
    // MARK: - Properties
    var codeID: String!
    var name: String!
    var category: Category!
    var location: CLLocationCoordinate2D?
    var addressCity: String?
    var addressStreet: String?
    var logoURL: String?
    var headerURL: String?
    var rating: Double = 0.0
    var isFavorite: Bool = false
    var phones: [String]?
    var schedule: Schedule?
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "OrganizationTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, name: String, category: Category, rating: Double, isFavorite: Bool, logoURL: String) {
        self.codeID = codeID
        self.name = name
        self.category = category
        self.rating = rating
        self.isFavorite = isFavorite
        self.logoURL = logoURL
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let category = aDecoder.decodeObject(forKey: "category") as! Category
        let rating = aDecoder.decodeObject(forKey: "rating") as! Double
        let isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as! Bool
        let logoURL = aDecoder.decodeObject(forKey: "logoURL") as! String

        self.init(codeID: codeID, name: name, category: category, rating: rating, isFavorite: isFavorite, logoURL: logoURL)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(isFavorite, forKey: "isFavorite")
        aCoder.encode(logoURL, forKey: "logoURL")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as? String
        self.name = dictionary["orgName"] as? String
        self.rating = (dictionary["rating"] as? Double)!
        self.isFavorite = (dictionary["isFavorite"] as? Bool)!
        
        if (dictionary["placeId"] as? String != nil) {
            // Get Location
            let locationManager = LocationManager()
            
            locationManager.geocodingAddress(byGoogleID: (dictionary["placeId"] as? String)!, completion: { coordinate, city, street in
                self.location = coordinate
                self.addressCity = city
                self.addressStreet = street
                
                completion()
            })            
        }
        
        if (dictionary["staticUrl"] as? String != nil) {
            self.logoURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["staticUrl"] as! String)"
        }
    }
}
