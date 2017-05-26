//
//  Discount+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Discount)
public class Discount: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "DiscountTableViewCell"
    var cellHeight: CGFloat = 50.0

    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], forManagedObject managedObject: NSManagedObject, isUserDiscount: Bool) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String, let percent = json["percent"] as? Int32, let status = json["status"] as? Bool, let dateStart = json["startTerm"] as? String, let dateEnd = json["endTerm"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let discountEntity = CoreDataManager.instance.entityForName("Discount") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: discountEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.percent = percent
        self.status = status
        self.isUserDiscount = isUserDiscount
        self.dateStart = dateStart.convertToDate(withDateFormat: .PriceDate) as NSDate
        self.dateEnd = dateEnd.convertToDate(withDateFormat: .PriceDate) as NSDate
        
        if let organizationID = json["orgUuid"] as? String {
            self.organizationID = organizationID
        }
        
        if let organization = managedObject as? Organization {
            if let organizationCodeID = self.organizationID, organizationCodeID == organization.codeID {
                self.organization = organization
            }
        }

        if let service = managedObject as? Service {
            self.service = service
        } else if let serviceID = json["serviceId"] as? String {
            let serviceEntity = CoreDataManager.instance.entityDidLoad(byName: "Service", andPredicateParameters: NSPredicate.init(format: "codeID == %@", serviceID)) as! Service
            
            if (!serviceEntity.codeID.isEmpty) {
                if (serviceEntity.discounts?.count == 0) {
                    serviceEntity.discounts = NSSet()
                }
                
                serviceEntity.addToDiscounts(self)
                self.service = serviceEntity
            }
        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
