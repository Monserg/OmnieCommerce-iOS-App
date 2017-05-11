//
//  Order+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var codeID: String
    @NSManaged public var comment: String?
    @NSManaged public var dateEnd: String?
    @NSManaged public var dateStart: String
    @NSManaged public var discount: Float
    @NSManaged public var isAvailable: Bool
    @NSManaged public var price: Float
    @NSManaged public var priceTotal: Float
    @NSManaged public var status: String
    @NSManaged public var organizationName: String
    @NSManaged public var serviceName: String

}
