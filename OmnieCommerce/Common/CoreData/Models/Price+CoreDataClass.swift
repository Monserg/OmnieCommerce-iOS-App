//
//  Price+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Price)
public class Price: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServicePriceTableViewCell"
    var cellHeight: CGFloat = 44.0

    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andNSManagedObject managedObject: NSManagedObject?) {
        guard let codeID = json["uuid"] as? String, let day = json["day"] as? UInt16, let price = json["price"] as? Double, let unit = json["unit"] as? UInt16, let dateCreated = json["createDate"] as? String, let ruleTimeStart = json["startRule"] as? String, let ruleTimeEnd = json["endRule"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let priceEntity = CoreDataManager.instance.entityForName("Price") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: priceEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.day = day
        self.dayName = day.convertToScheduleString()
        self.price = price
        self.unit = unit
        self.unitName = unit.convertToUnitString() ?? "ZZZ"
        self.dateCreated = dateCreated.convertToDate(withDateFormat: .PriceDate) as NSDate
        self.ruleTimeStart = ruleTimeStart
        self.ruleTimeEnd = ruleTimeEnd
        
        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }

        if let service = managedObject as? Service {
            self.service = service
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
