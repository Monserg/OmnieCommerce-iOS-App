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
    convenience init?(json: [String: AnyObject], andRelationshipObject managedObject: NSManagedObject) {
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
        self.dateStart = dateStart.convertToDate(withDateFormat: .ResponseDate) as NSDate
        self.dateEnd = dateEnd.convertToDate(withDateFormat: .ResponseDate) as NSDate
        
        if let organization = managedObject as? Organization {
            self.organization = organization
        }

        if let service = managedObject as? Service {
            self.service = service
        } else if let serviceID = json["serviceId"] as? String {
            let serviceEntity = CoreDataManager.instance.entityDidLoad(byName: "Service", andPredicateParameter: serviceID) as! Service
            
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
