//
//  Review+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var organizationID: String?
    @NSManaged public var serviceID: String?
    @NSManaged public var userName: String?
    @NSManaged public var rating: Double
    @NSManaged public var content: String?
    @NSManaged public var dateCreate: NSDate
    @NSManaged public var typeValue: String?

}
