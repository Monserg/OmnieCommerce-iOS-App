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
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject]) {
        // Prepare to save common data
        self.codeID = json["uuid"] as! String
        self.name = json["name"] as! String
        self.unit = json["unit"] as! UInt16
        self.unitName = unit.convertToUnitString() ?? "XXX"
        self.price = json["price"] as! Double
        self.isAvailable = true
        
        if let minValue = json["minValue"] as? Double {
            self.minValue = minValue
        }

        if let maxValue = json["maxValue"] as? Double {
            self.maxValue = maxValue
        }

        if let duration = json["duration"] as? Double {
            self.duration = duration
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
