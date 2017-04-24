//
//  AdditionalService+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(AdditionalService)
public class AdditionalService: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "AdditionalServiceTableViewCell"
    var cellHeight: CGFloat = 52.0
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andRelationshipObject managedObject: NSManagedObject) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String, let unit = json["unit"] as? UInt16, let price = json["price"] as? Double else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let additionalServiceEntity = CoreDataManager.instance.entityForName("AdditionalService") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: additionalServiceEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.unit = unit
        self.unitName = unit.convertToUnitString() ?? "XXX"
        self.price = price
        
        if let minValue = json["minValue"] as? Int16 {
            self.minValue = minValue
        }

        if let maxValue = json["maxValue"] as? Int16 {
            self.maxValue = maxValue
        }

        if let duration = json["duration"] as? Int64 {
            self.duration = duration
        }
        
        if let service = managedObject as? Service {
            self.service = service
        }
        
        // Common discounts
//        self.discounts = NSSet()
//        
//        if let commonDiscounts = json["discountsCommon"] as? NSArray {
//            for dictionary in commonDiscounts {
//                let discountCommon = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
//                discountCommon.isUserDiscount = false
//                
//                self.addToDiscounts(discountCommon)
//            }
//        }
//        
//        // User discounts
//        if let userDiscounts = json["discountsForUser"] as? NSArray {
//            for dictionary in userDiscounts {
//                let discountUser = Discount.init(json: dictionary as! [String : AnyObject], andRelationshipObject: self)!
//                discountUser.isUserDiscount = true
//                
//                self.addToDiscounts(discountUser)
//            }
//        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
