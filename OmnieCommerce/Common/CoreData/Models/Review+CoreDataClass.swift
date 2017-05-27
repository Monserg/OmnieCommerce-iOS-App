//
//  Review+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

enum ReviewType: String {
    case UserReview             =   "UserReview"
    case ServiceReview          =   "ServiceReview"
    case OrganizationReview     =   "OrganizationReview"
}

@objc(Review)
public class Review: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ReviewCollectionViewCell"
    var cellHeight: CGFloat = 143.0
        
    var type: ReviewType! {
        set {
            self.typeValue = newValue.rawValue
        }
        
        get {
            return ReviewType.init(rawValue: self.typeValue)
        }
    }
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], withType type: ReviewType) {
        guard let codeID = json["uuid"] as? String, let dateCreate = json["date"] as? String, let rating = json["rating"] as? Double else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let reviewEntity = CoreDataManager.instance.entityForName("Review") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: reviewEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.dateCreate = dateCreate.convertToDate(withDateFormat: .PriceDate) as NSDate
        self.rating = rating
        self.type = type
        
        if let userName = json["userName"] as? String {
            self.userName = userName
        }

        if let userID = json["userId"] as? String {
            self.userID = userID
        }

        if let content = json["review"] as? String {
            self.content = content
        }
        
        if let organizationID = json["organizationId"] as? String {
            self.organizationID = organizationID
            self.codeID = "\(organizationID)-\(type.rawValue)"
        }

        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }
        
        if let imageID = json["userStaticUrl"] as? String {
            self.imageID = imageID
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
