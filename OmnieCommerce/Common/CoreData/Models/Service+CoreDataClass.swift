//
//  Service+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Service)
public class Service: NSManagedObject, InitCellParameters, PointAnnotationBinding {
    // Confirm SearchObject Protocol
    var name: String! {
        set {
            self.nameValue = newValue
        }
        
        get {
            return self.nameValue!
        }
    }

    // Confirm PointAnnotationBinding Protocol
    var latitude: CLLocationDegrees? {
        set {
            self.latitudeValue = Double(newValue!)
        }
        
        get {
            return self.latitudeValue
        }
    }
    
    var longitude: CLLocationDegrees? {
        set {
            self.longitudeValue = Double(newValue!)
        }
        
        get {
            return self.longitudeValue
        }
    }
    
    var addressCity: String? {
        set {
            self.addressCityValue = newValue
        }
        
        get {
            return self.addressCityValue
        }
    }
    
    var addressStreet: String? {
        set {
            self.addressStreetValue = newValue
        }
        
        get {
            return self.addressStreetValue
        }        
    }
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServiceTableViewCell"
    var cellHeight: CGFloat = 96.0

    
    
    
    // MARK: - Properties
    var category: Category?
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andOrganization organization: Organization?) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let serviceEntity = CoreDataManager.instance.entityForName("Service") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: serviceEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.organization = organization
        self.isNameNeedHide = false
        self.needBackgroundColorSet = false

        if let organizationName = json["orgName"] as? String {
            self.organizationName = organizationName
        }
        
        if let isFavorite = json["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
    
        if let rating = json["rating"] as? Double {
            self.rating = rating
        }
    
        if let logoURL = json["staticUrl"] as? String {
            self.logoURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(logoURL)"
        }
        
        // Prices
        if let prices = json["servicePrices"] as? [Any] {
            self.prices = NSSet()
            
            for json in prices {
                self.addToPrices(Price.init(json: json as! [String: AnyObject], andNSManagedObject: self)!)
            }
        }
        
        // Discounts
//        if let discounts = json[""] as? [AnyObject] {
//            
//        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }

}
