//
//  Review+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var content: String?
    @NSManaged public var dateCreate: NSDate
    @NSManaged public var rating: Double
    @NSManaged public var typeValue: String
    @NSManaged public var userName: String?
    @NSManaged public var codeID: String
    @NSManaged public var userID: String?
    @NSManaged public var imageID: String?
    @NSManaged public var serviceID: String?
    @NSManaged public var organizationID: String?
    @NSManaged public var organization: Organization?
    @NSManaged public var service: Service?

}
