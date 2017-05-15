//
//  Price+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var codeID: String
    @NSManaged public var day: UInt16
    @NSManaged public var dayName: String
    @NSManaged public var price: Double
    @NSManaged public var unit: UInt16
    @NSManaged public var unitName: String
    @NSManaged public var dateCreated: NSDate
    @NSManaged public var ruleTimeStart: String
    @NSManaged public var ruleTimeEnd: String
    @NSManaged public var serviceID: String
    @NSManaged public var service: Service?

}
