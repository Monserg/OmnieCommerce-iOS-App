//
//  Order+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var codeID: String
    @NSManaged public var dateStart: String
    @NSManaged public var dateEnd: String
    @NSManaged public var status: String
    @NSManaged public var discount: Float
    @NSManaged public var price: Float
    @NSManaged public var priceTotal: Float
    @NSManaged public var comment: String?

}
