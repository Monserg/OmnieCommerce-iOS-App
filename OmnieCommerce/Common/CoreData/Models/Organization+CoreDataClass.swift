//
//  Organization+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Organization)
public class Organization: NSManagedObject, InitCellParameters, PointAnnotationBinding {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "OrganizationTableViewCell"
    var cellHeight: CGFloat = 96.0

    
    var canUserSendReview: Bool = false
    var isCommonProfile: Bool = true
    
    
    // Confirm PointAnnotationBinding Protocol
    var name: String! {
        set {
            self.nameValue = newValue
        }
        
        get {
            return self.nameValue
        }
    }
    
    var latitude: CLLocationDegrees? {
        set {
            self.latitudeValue = newValue!
        }
        
        get {
            return self.latitudeValue
        }
    }
    
    var longitude: CLLocationDegrees? {
        set {
            self.longitudeValue = newValue!
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
    
    
    // From full API response
    var rating: Double?
    var email: String?
    var headerURL: String?
    var gallery: [GalleryImage]?
    var services: [Service]?
    var discountsCommon: [Discount]?
    var discountsUser: [Discount]?
    

    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject]) {
        guard let codeID = json["uuid"] as? String, let name = json["orgName"] as? String, let isFavorite = json["isFavorite"] as? Bool else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let organizationEntity = CoreDataManager.instance.entityForName("Organization") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: organizationEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.isFavorite = isFavorite
        
        if let imageURL = json["staticUrl"] as? String {
            self.logoURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(imageURL)"
        }

        // Prepare to save full data
        if let phones = json["phones"] as? [String] {
            self.phones = phones
        }
        
        if let scheduleItems = json["timeSheets"] as? NSArray {
            for dictionary in scheduleItems {
                let _ = Schedule.init(json: dictionary as! [String : AnyObject], andOrganization: self)
            }
            
            self.schedules = NSSet.init(array: CoreDataManager.instance.entitiesDidLoad(byName: "Schedule", andPredicateParameter: self.codeID)!)
        }

        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        if let describeTitle = json["descriptionTitle"] as? String {
            self.descriptionTitle = describeTitle
        }

        if let describeContent = json["descriptionContent"] as? String {
            self.descriptionContent = describeContent
        }

//        @NSManaged public var phones: [String]?


        
        
//        for json in subcategoriesList {
//            let subcategory = Subcategory.init(json: json as! [String: AnyObject], andType: .Subcategory)
//            subcategory!.category = self
//            
//            self.subcategories!.adding(subcategory!)
//        }
        
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func googlePlaceDidLoad(positionID: String, completion: @escaping HandlerSendButtonCompletion) {
        // Get Location
        let locationManager = LocationManager()
        
        locationManager.geocodingAddress(byGoogleID: positionID, completion: { coordinate, city, street in
            self.latitude = (coordinate?.latitude)!
            self.longitude = (coordinate?.longitude)!
            self.addressCity = city!
            self.addressStreet = street!
            
            CoreDataManager.instance.didSaveContext()
            completion()
        })
    }
}
