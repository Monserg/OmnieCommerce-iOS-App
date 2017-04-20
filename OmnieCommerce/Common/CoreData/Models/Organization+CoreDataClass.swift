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
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var addressCity: String?
    var addressStreet: String?
    
    
    // From full API response
    var rating: Double?
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
}
