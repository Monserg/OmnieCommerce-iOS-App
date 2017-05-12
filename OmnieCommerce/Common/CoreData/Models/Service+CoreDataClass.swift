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
    let durationMin: CGFloat = 30.0
    var durationMinRate: CGFloat = 60.0

    // MARK: - Properties
    var category: Category?

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

        if let canUserSendReview = json["canSendReview"] as? Bool {
            self.canUserSendReview = canUserSendReview
        }
        
        if let organizationName = json["orgName"] as? String {
            self.organizationName = organizationName
        }
        
        if let descriptionContent = json["description"] as? String {
            self.descriptionContent = descriptionContent
        }
        
        if let isFavorite = json["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
        
        if let minDuration = json["minDuration"] as? Bool {
            self.minDuration = minDuration
        }
    
        if let duration = json["duration"] as? Int64 {
            self.duration = duration
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
        
        // Categories
        if let categories = json["categories"] as? [String] {
            self.categories = categories
        }
        
        // Common discounts
        self.discounts = NSSet()
        
        if let commonDiscounts = json["discountsCommon"] as? NSArray {
            for dictionary in commonDiscounts {
                let discountCommon = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
                discountCommon.isUserDiscount = false
                
                self.addToDiscounts(discountCommon)
            }
        }
        
        // User discounts
        if let userDiscounts = json["discountsUser"] as? NSArray {
            for dictionary in userDiscounts {
                let discountUser = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
                discountUser.isUserDiscount = true
                
                self.addToDiscounts(discountUser)
            }
        }
        
        // Google place
        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        // Additional services
        if let additionalServices = json["subServiceList"] as? [Any] {
            self.additionalServices = NSSet()
            
            for json in additionalServices {
                self.addToAdditionalServices(AdditionalService.init(json: json as! [String: AnyObject], andRelationshipObject: self)!)
            }
        }
        
        // Gallery images
        if let galleryImages = json["serviceGallery"] as? NSArray {
            self.images = NSSet()
            
            for dictionary in galleryImages {
                if let image = GalleryImage.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self) {
                    self.addToImages(image)
                }
            }
        }
        
        // Reviews
        // TODO: - ADD MAPPING REVIEWS AFTER CHANGE API
    }

    deinit {
        print("\(type(of: self)) deinit")
    }

    
    // MARK: - Custom Functions
    func googlePlaceDidLoad(positionID: String, completion: @escaping HandlerSendButtonCompletion) {
        // Get Location
        let locationManager = LocationManager()
        
        locationManager.geocodingAddress(byGoogleID: positionID, completion: { coordinate, city, street in
            self.latitude = coordinate?.latitude ?? 0.0
            self.longitude = coordinate?.longitude ?? 0.0
            self.addressCity = city ?? "Zorro"
            self.addressStreet = street ?? "Zorro"
            
            completion()
        })
    }
}
