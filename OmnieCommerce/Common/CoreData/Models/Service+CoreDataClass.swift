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
            return self.nameValue
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
    
    
//    // MARK: - Class Initialization
//    convenience init?(json: [String: AnyObject], forOrganization organization: Organization?, forList listName: String) {
//        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String else {
//            return nil
//        }
//        
//        // Check Entity available in CoreData
//        guard let serviceEntity = CoreDataManager.instance.entityForName("Service") else {
//            return nil
//        }
//        
//        // Create Entity
//        self.init(entity: serviceEntity, insertInto: CoreDataManager.instance.managedObjectContext)
//    }
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forOrganization organization: Organization?, forList listName: String) {
        // Prepare to save common data
        if let codeID = json["uuid"] as? String {
            self.codeID = codeID
        }
        
        if let name = json["name"] as? String {
            self.name = name
        }

        self.organization = organization
        self.isNameNeedHide = false
        self.needBackgroundColorSet = false

        if let organizationName = json["orgName"] as? String {
            self.organizationName = organizationName
        }
        
        if let imageID = json["staticUrl"] as? String {
            self.imageID = imageID
        }

        if let isFavorite = json["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }

        self.addToLists(Lists.init(name: listName, item: self))
        
        
        // Prepare to save additional data
        if let canUserSendReview = json["canSendReview"] as? Bool {
            self.canUserSendReview = canUserSendReview
        }
        
        if let descriptionContent = json["description"] as? String {
            self.descriptionContent = descriptionContent
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
    
        
        // Prices
        if let prices = json["servicePrices"] as? [Any] {
            for json in prices {
                self.addToPrices(Price.init(json: json as! [String: AnyObject], andNSManagedObject: self)!)
            }
        }
        
        // SubCategories
        // FIXME: - WHERE USE SERVICE SUBCATEGORIES ???
        /*
        if let subCategories = json["categories"] as? NSArray, subCategories.count > 0 {
            for subCategory in subCategories {
                let categoryEntity = CoreDataManager.instance.entityDidLoad(byName: "Category", andPredicateParameters: NSPredicate.init(format: "codeID == %@", (subCategory as! [String: AnyObject])["categoryId"] as! String))
                
                if let category = categoryEntity as? Category {
                    self.addToSubCategories(Subcategory.init(json: subCategory as! [String: AnyObject], category: category, andType: .Service, managedObject: self)!)
                }
            }
        }
        */
        
        // Common discounts
        if let commonDiscounts = json["discountsCommon"] as? NSArray, commonDiscounts.count > 0 {
            for commonDiscount in commonDiscounts {
                self.addToDiscounts(Discount.init(json: commonDiscount as! [String: AnyObject], forManagedObject: self, isUserDiscount: false)!)
            }
        }
        
        // User discounts
        if let userDiscounts = json["discountsUser"] as? NSArray, userDiscounts.count > 0 {
            for userDiscount in userDiscounts {
                self.addToDiscounts(Discount.init(json: userDiscount as! [String: AnyObject], forManagedObject: self, isUserDiscount: true)!)
            }
        }
        
        // Google place
        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        // Additional services
        if let additionalServices = json["subServiceList"] as? [Any] {
            for json in additionalServices {
                self.addToAdditionalServices(AdditionalService.init(json: json as! [String: AnyObject], andRelationshipObject: self)!)
            }
        }
        
        // Gallery images
        if let galleryImages = json["serviceGallery"] as? NSArray, galleryImages.count > 0 {
            for dictionary in galleryImages {
                if let image = GalleryImage.init(json: dictionary as! [String: AnyObject], andRelationshipObject: self) {
                    self.addToImages(image)
                }
            }
        }
        
        // Own Review
        if let userReview = json["ownReview"] as? [String: AnyObject] {
            self.addToReviews(Review.init(json: userReview, forManagedObject: self, withType: .UserReview)!)
        }

        // Service Reviews
        if let serviceReviews = json["serviceReviews"] as? NSArray, serviceReviews.count > 0 {
            for serviceReview in serviceReviews {
                self.addToReviews(Review.init(json: serviceReview as! [String: AnyObject], forManagedObject: self, withType: .ServiceReview)!)
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
            self.latitude = coordinate?.latitude ?? 0.0
            self.longitude = coordinate?.longitude ?? 0.0
            self.addressCity = city ?? "Zorro"
            self.addressStreet = street ?? "Zorro"
            
            completion()
        })
    }
}
