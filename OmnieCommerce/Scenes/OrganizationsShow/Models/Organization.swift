
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

class Organization: NSObject, NSCoding, InitCellParameters, SearchObject, PointAnnotationBinding {
    // MARK: - Properties
    var category: Category?
    var canUserSendReview: Bool = false
    var isCommonProfile: Bool = true

    // From common API response
    var codeID: String!
    var logoURL: String?
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
    var cellIdentifier: String = "OrganizationTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    // From full API response
    var email: String?
    var headerURL: String?
    var descriptionTitle: String?
    var descriptionContent: String?
    var gallery: [GalleryImage]?
    var phones: [String]?
    var schedules: [Schedule]?
    var services: [Service]?
    var discountsCommon: [Discount]?
    var discountsUser: [Discount]?
    
    // MARK: - Class Initialization
    init(withCommonProfile isCommonProfile: Bool) {
        super.init()
        
        self.isCommonProfile = isCommonProfile
    }
    
    init(category: Category?, name: String, canUserSendReview: Bool, codeID: String, logoURL: String?, rating: Double?, isFavorite: Bool, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, city: String?, street: String?, email: String?, headerURL: String?, descriptionTitle: String?, descriptionContent: String?, gallery: [GalleryImage]?, phones: [String]?, schedules: [Schedule]?, services: [Service]?, discountsCommon: [Discount]?, discountsUser: [Discount]?) {
        // Common profile
        self.category = category
        self.name = name
        self.canUserSendReview = canUserSendReview
        self.codeID = codeID
        self.logoURL = logoURL
        self.rating = rating
        self.isFavorite = isFavorite
        self.latitude = latitude
        self.longitude = longitude
        self.addressCity = city
        self.addressStreet = street
        
        // Full profile
        self.email = email
        self.headerURL = headerURL
        self.descriptionTitle = descriptionTitle
        self.descriptionContent = descriptionContent
        self.gallery = gallery
        self.phones = phones
        self.schedules = schedules
        self.services = services
        self.discountsCommon = discountsCommon
        self.discountsUser = discountsUser
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        // Common profile
        let category = aDecoder.decodeObject(forKey: "category") as? Category
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let canUserSendReview = aDecoder.decodeBool(forKey: "canUserSendReview")
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let logoURL = aDecoder.decodeObject(forKey: "logoURL") as? String
        let rating = aDecoder.decodeObject(forKey: "rating") as? Double
        let isFavorite = aDecoder.decodeBool(forKey: "isFavorite")
        let latitude = aDecoder.decodeObject(forKey: "latitude") as? CLLocationDegrees
        let longitude = aDecoder.decodeObject(forKey: "longitude") as? CLLocationDegrees
        let addressCity = aDecoder.decodeObject(forKey: "addressCity") as? String
        let addressStreet = aDecoder.decodeObject(forKey: "addressStreet") as? String
        
        // Full profile
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let headerURL = aDecoder.decodeObject(forKey: "headerURL") as? String
        let descriptionTitle = aDecoder.decodeObject(forKey: "descriptionTitle") as? String
        let descriptionContent = aDecoder.decodeObject(forKey: "descriptionContent") as? String
        let gallery = aDecoder.decodeObject(forKey: "gallery") as? [GalleryImage]
        let phones = aDecoder.decodeObject(forKey: "phones") as? [String]
        let schedules = aDecoder.decodeObject(forKey: "schedules") as? [Schedule]
        let services = aDecoder.decodeObject(forKey: "services") as? [Service]
        let discountsCommon = aDecoder.decodeObject(forKey: "discountsCommon") as? [Discount]
        let discountsUser = aDecoder.decodeObject(forKey: "discountsUser") as? [Discount]
        
        self.init(category: category, name: name, canUserSendReview: canUserSendReview, codeID: codeID, logoURL: logoURL, rating: rating, isFavorite: isFavorite, latitude: latitude, longitude: longitude, city: addressCity, street: addressStreet, email: email, headerURL: headerURL, descriptionTitle: descriptionTitle, descriptionContent: descriptionContent, gallery: gallery, phones: phones, schedules: schedules, services: services, discountsCommon: discountsCommon, discountsUser: discountsUser)
    }
    
    func encode(with aCoder: NSCoder) {
        // Common profile
        aCoder.encode(category, forKey: "category")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(canUserSendReview, forKey: "canUserSendReview")
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(logoURL, forKey: "logoURL")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(isFavorite, forKey: "isFavorite")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(addressCity, forKey: "addressCity")
        aCoder.encode(addressStreet, forKey: "addressStreet")

        // Full profile
        aCoder.encode(email, forKey: "orgEmail")
        aCoder.encode(headerURL, forKey: "headerURL")
        aCoder.encode(descriptionTitle, forKey: "descriptionTitle")
        aCoder.encode(descriptionContent, forKey: "descriptionContent")
        aCoder.encode(gallery, forKey: "gallery")
        aCoder.encode(phones, forKey: "phones")
        aCoder.encode(schedules, forKey: "schedules")
        aCoder.encode(services, forKey: "services")
        aCoder.encode(discountsCommon, forKey: "discountsCommon")
        aCoder.encode(discountsUser, forKey: "discountsUser")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Organization: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        // Common profile
        self.name = dictionary["orgName"] as! String
        self.codeID = dictionary["uuid"] as! String
        
        if (dictionary["staticUrl"] as? String != nil) {
            self.logoURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["staticUrl"] as! String)"
        }
        
        if (dictionary["rating"] as? Double != nil) {
            self.rating = dictionary["rating"] as? Double
        }
        
        self.isFavorite = dictionary["isFavorite"] as! Bool
        
        // Full profile
        if (!isCommonProfile) {
            if (dictionary["canSendReview"] as! Bool) {
                self.canUserSendReview = dictionary["canSendReview"] as! Bool
            }
            
            if (dictionary["orgEmail"] as? String != nil) {
                self.email = dictionary["orgEmail"] as? String
            }
            
            if (dictionary["backgroundImageUrl"] as? String != nil) {
                self.headerURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["backgroundImageUrl"] as! String)"
            }
            
            if (dictionary["descriptionTitle"] as? String != nil) {
                self.descriptionTitle = dictionary["descriptionTitle"] as? String
            }
            
            if (dictionary["descriptionContent"] as? String != nil) {
                self.descriptionContent = dictionary["descriptionContent"] as? String
            }
            
            if let galleryImages = dictionary["gallery"] as? NSArray {
                var items = [GalleryImage]()
                
                for dictionary in galleryImages {
                    let image = GalleryImage()
                    image.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(image)
                }
                
                self.gallery = items
            }
            
            if (dictionary["phones"] as? [String] != nil) {
                self.phones = dictionary["phones"] as? [String]
            }
            
            if let scheduleItems = dictionary["timeSheets"] as? NSArray {
                var items = [Schedule]()
                
                for dictionary in scheduleItems {
                    let schedule = Schedule()
                    schedule.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(schedule)
                    
                    if (schedule.launchTimeStart != nil) {
                        let launchSchedule = Schedule.init(codeID: schedule.codeID,
                                                           name: "Lunch break".localized(),
                                                           day: 0,
                                                           workTimeStart: schedule.launchTimeStart!,
                                                           workTimeEnd: schedule.launchTimeEnd!,
                                                           launchTimeStart: nil,
                                                           launchTimeEnd: nil)
                        items.append(launchSchedule)
                    }
                }
                
                self.schedules = items
            }
            
            if let serviceItems = dictionary["services"] as? NSArray {
                var items = [Service]()
                
                for dictionary in serviceItems {
                    let service = Service.init(withCommonProfile: false)
                    service.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(service)
                }
                
                self.services = items
            }
            
            if let commonDiscounts = dictionary["discountsCommon"] as? NSArray {
                var items = [Discount]()
                
                for dictionary in commonDiscounts {
                    let discount = Discount()
                    discount.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(discount)
                }
                
                self.discountsCommon = items
            }
            
            if let userDiscounts = dictionary["discountsForUser"] as? NSArray {
                var items = [Discount]()
                
                for dictionary in userDiscounts {
                    let discount = Discount()
                    discount.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                    items.append(discount)
                }
                
                self.discountsUser = items
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


// MARK: - NSCopying
extension Organization: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Organization.init(withCommonProfile: self.isCommonProfile)
        return copy
    }
}
