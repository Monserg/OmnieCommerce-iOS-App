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
public class Organization: NSManagedObject, InitCellParameters, PointAnnotationBinding, SearchObject {
    // MARK: - Properties
    var workStartTime = 9
    var workTimeDuration = 18
    var canUserSendReview: Bool = false

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "OrganizationTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    // Confirm PointAnnotationBinding & SearchObject Protocols
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


    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forList listName: String) {
        // Prepare to save common data
        if let codeID = json["uuid"] as? String {
            self.codeID = codeID
        }
        
        if let name = json["orgName"] as? String {
            self.name = name
        }
        
        if let isFavorite = json["isFavorite"] as? Bool {
            self.isFavorite = isFavorite
        }
        
        if let imageID = json["staticUrl"] as? String {
            self.imageID = imageID
        }
        
        self.addToLists(Lists.init(name: listName, item: self))

        
        // Prepare to save additional data
        if let canSendReview = json["canSendReview"] as? Bool {
            self.canSendReview = canSendReview
        }
        
        // Google place
        if let positionID = json["placeId"] as? String {
            self.placeID = positionID
        }
        
        // Phones
        if let phones = json["phones"] as? [String], phones.count > 0 {
            self.phones = phones
        }
 
        // Descriptions
        if let describeTitle = json["descriptionTitle"] as? String {
            self.descriptionTitle = describeTitle
        }
        
        if let describeContent = json["descriptionContent"] as? String {
            self.descriptionContent = describeContent
        }
        
        // Own Review
        if let userReview = json["ownReview"] as? [String: AnyObject] {
            self.addToReviews(Review.init(json: userReview, withType: .UserReview)!)
        }
        
        // Service Reviews
        if let serviceReviews = json["serviceReviews"] as? NSArray, serviceReviews.count > 0 {
            for serviceReview in serviceReviews {
                self.addToReviews(Review.init(json: serviceReview as! [String: AnyObject], withType: .ServiceReview)!)
            }
        }

        // Organization reviews
        if let organizationReviews = json["organizationReviews"] as? NSArray, organizationReviews.count > 0 {
            for organizationReview in organizationReviews {
                self.addToReviews(Review.init(json: organizationReview as! [String: AnyObject], withType: .OrganizationReview)!)
            }
        }
        
        // Schedules / TimeSheets
        if let timeSheets = json["timeSheets"] as? NSArray, timeSheets.count > 0 {
            for timeSheet in timeSheets {
                self.addToSchedules(Schedule.init(json: timeSheet as! [String: AnyObject], andOrganization: self)!)
            }
        }
        
        // Services
        if let services = json["services"] as? [[String: AnyObject]], services.count > 0 {
            for jsonService in services {
                if let serviceID = jsonService["uuid"] as? String {
                    if let service = CoreDataManager.instance.entityBy("Service", andCodeID: serviceID) as? Service {
                        service.profileDidUpload(json: jsonService, forList: keyService)
                        self.addToServices(service)
                    }
                }
            }
        }

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
        
        // Gallery images
        if let galleryImages = json["serviceGallery"] as? [[String: AnyObject]], galleryImages.count > 0 {
            for jsonGalleryImage in galleryImages {
                if let codeID = jsonGalleryImage["imageId"] as? String {
                    if let image = CoreDataManager.instance.entityBy("GalleryImage", andCodeID: codeID) as? GalleryImage {
                        image.profileDidUpload(json: json)
                        self.addToImages(image)
                    }
                }
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
            self.latitudeValue = (coordinate?.latitude)!
            self.longitudeValue = (coordinate?.longitude)!
            self.addressCityValue = city!
            self.addressStreetValue = street!
            
            completion()
        })
    }
}
