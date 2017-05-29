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
public class Service: NSManagedObject, InitCellParameters, PointAnnotationBinding, SearchObject {
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

    // Confirm PointAnnotationBinding Protocols
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
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forList listName: String) {
        // Prepare to save common data
        if let codeID = json["uuid"] as? String {
            self.codeID = codeID
        }
        
        if let name = json["name"] as? String, !name.isEmpty {
            self.name = name
        } else {
            self.name = "Zorro"
        }

        self.isNameNeedHide = false
        self.needBackgroundColorSet = false

        if let organizationName = json["orgName"] as? String {
            self.organizationName = organizationName
        }
        
        if let imageID = json["imageId"] as? String {
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
        if let prices = json["servicePrices"] as? [[String: AnyObject]], prices.count > 0 {
            for jsonPrice in prices {
                if let codeID = jsonPrice["uuid"] as? String {
                    if let price = CoreDataManager.instance.entityBy("Price", andCodeID: codeID) as? Price {
                        price.profileDidUpload(json: jsonPrice, forService: self)
                        
                        self.addToPrices(price)
                    }
                }
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
        if let commonDiscounts = json["discountsCommon"] as? [[String: AnyObject]], commonDiscounts.count > 0 {
            for jsonCommonDiscount in commonDiscounts {
                if let codeID = jsonCommonDiscount["uuid"] as? String {
                    if let commonDiscount = CoreDataManager.instance.entityBy("Discount", andCodeID: codeID) as? Discount {
                        commonDiscount.profileDidUpload(json: jsonCommonDiscount, isUserDiscount: false)
                        self.addToDiscounts(commonDiscount)
                    }
                }
            }
        }
        
        // User discounts
        if let userDiscounts = json["discountsForUser"] as? [[String: AnyObject]], userDiscounts.count > 0 {
            for jsonUserDiscount in userDiscounts {
                if let codeID = jsonUserDiscount["uuid"] as? String {
                    if let userDiscount = CoreDataManager.instance.entityBy("Discount", andCodeID: codeID) as? Discount {
                        userDiscount.profileDidUpload(json: jsonUserDiscount, isUserDiscount: true)
                        self.addToDiscounts(userDiscount)
                    }
                }
            }
        }
        
        // Google place
        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        // Additional services
        if let additionalServices = json["subServiceList"] as? [[String: AnyObject]] {
            for jsonAdditionalService in additionalServices {
                if let codeID = jsonAdditionalService["uuid"] as? String {
                    if let additionalService = CoreDataManager.instance.entityBy("AdditionalService", andCodeID: codeID) as? AdditionalService {
                        additionalService.profileDidUpload(json: jsonAdditionalService)
                        addToAdditionalServices(additionalService)
                    }
                }
            }
        }
        
        // Gallery images
        if let galleryImages = json["serviceGallery"] as? [[String: AnyObject]], galleryImages.count > 0 {
            for json in galleryImages {
                if let imageID = json["imageId"] as? String {
                    if let galleryImageEntity = CoreDataManager.instance.entityBy("GalleryImage", andCodeID: imageID) as? GalleryImage {
                        galleryImageEntity.profileDidUpload(json: json)
                        addToImages(galleryImageEntity)
                    }
                }
            }
        }
        
        // Own Review
//        if let userReview = json["ownReview"] as? [String: AnyObject] {
//            self.addToReviews(Review.init(json: userReview, withType: .UserReview)!)
//        }
//
//        // Service Reviews
//        if let serviceReviews = json["serviceReviews"] as? NSArray, serviceReviews.count > 0 {
//            for serviceReview in serviceReviews {
//                self.addToReviews(Review.init(json: serviceReview as! [String: AnyObject], withType: .ServiceReview)!)
//            }
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
            self.latitude = coordinate?.latitude ?? 0.0
            self.longitude = coordinate?.longitude ?? 0.0
            self.addressCity = city ?? "Zorro"
            self.addressStreet = street ?? "Zorro"
            
            completion()
        })
    }
}
