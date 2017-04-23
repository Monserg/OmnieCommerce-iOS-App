//
//  Discount+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Discount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Discount> {
        return NSFetchRequest<Discount>(entityName: "Discount")
    }

    @NSManaged public var codeID: String
    @NSManaged public var name: String
    @NSManaged public var percent: Int32
    @NSManaged public var status: Bool
    @NSManaged public var isUserDiscount: Bool
    @NSManaged public var dateStart: NSDate
    @NSManaged public var dateEnd: NSDate
    @NSManaged public var organization: Organization?
    @NSManaged public var service: Service?

}
