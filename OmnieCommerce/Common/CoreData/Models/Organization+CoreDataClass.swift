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
    var workStartTime = 9
    var workTimeDuration = 18

    // MARK: - Properties
    var canUserSendReview: Bool = false

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "OrganizationTableViewCell"
    var cellHeight: CGFloat = 96.0
    
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


    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], forList listName: String) {
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
        
        if let imageID = json["staticUrl"] as? String {
            self.imageID = imageID
        }
        
        self.addToLists(Lists.init(name: listName, item: self))

        
        // Prepare to save additional data
        // Phones
        if let phones = json["phones"] as? [String], phones.count > 0 {
            self.phones = phones
        }
 
        // Reviews
        // Organization reviews
        // TODO: - ADD MAPPING REVIEWS AFTER CHANGE API
        if let canSendReview = json["canSendReview"] as? Bool {
            self.canSendReview = canSendReview
        }
        
        /*
        if let reviewsOrganization = json["organizationReviews"] as? [Any] {
            self.organizationReviews = NSSet()
            
            for dictionary in reviewsOrganization {
                self.addToOrganizationReviews(Review.init(json: dictionary as! [String: AnyObject], andType: .OrganizationReview)!)
            }
        }
        */
        
        // Schedules
        if let scheduleItems = json["timeSheets"] as? NSArray, scheduleItems.count > 0 {
            for dictionary in scheduleItems {
                let _ = Schedule.init(json: dictionary as! [String : AnyObject], andOrganization: self)
            }
            
            self.schedules = NSSet.init(array: CoreDataManager.instance.entitiesDidLoad(byName: "Schedule", andPredicateParameter: ["organization.codeID": self.codeID])!)
        }
        
        // Google place
        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        // Descriptions
        if let describeTitle = json["descriptionTitle"] as? String {
            self.descriptionTitle = describeTitle
        }

        if let describeContent = json["descriptionContent"] as? String {
            self.descriptionContent = describeContent
        }

        // Services
        if let services = json["services"] as? NSArray, services.count > 0 {
            self.services = NSSet()
            
            for json in services {
                let service = Service.init(json: json as! [String: AnyObject], forOrganization: self, forList: keyService)
                self.addToServices(service!)
            }
        }

        // Common discounts
        if let commonDiscounts = json["discountsCommon"] as? NSArray, commonDiscounts.count > 0 {
            self.discounts = NSSet()
            
            for dictionary in commonDiscounts {
                let discountCommon = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
                discountCommon.isUserDiscount = false
                
                self.addToDiscounts(discountCommon)
            }
        }
        
        // User discounts
        if let userDiscounts = json["discountsForUser"] as? NSArray, userDiscounts.count > 0 {
            for dictionary in userDiscounts {
                let discountUser = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
                discountUser.isUserDiscount = true
                
                self.addToDiscounts(discountUser)
            }
        }
        
        // Gallery images
        if let galleryImages = json["gallery"] as? NSArray, galleryImages.count > 0 {
            self.images = NSSet()
            
            for dictionary in galleryImages {
                let image = GalleryImage.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)
                self.addToImages(image!)
            }
        }
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
            
            completion()
        })
    }
}
