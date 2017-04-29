//
//  Order+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andOrganization organization: Organization?) {
        guard let codeID = json["uuid"] as? String, let dateStart = json["start"] as? String, let dateEnd = json["end"] as? String, let status = json["status"] as? String, let discount = json["discount"] as? Float, let price = json["price"] as? Float, let priceTotal = json["totalPrice"] as? Float else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let orderEntity = CoreDataManager.instance.entityForName("Order") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: orderEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.status = status
        self.discount = discount
        self.price = price
        self.priceTotal = priceTotal
    }
}
