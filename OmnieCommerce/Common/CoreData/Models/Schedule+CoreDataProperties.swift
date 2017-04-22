//
//  Schedule+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Schedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Schedule> {
        return NSFetchRequest<Schedule>(entityName: "Schedule")
    }

    @NSManaged public var codeID: String
    @NSManaged public var name: String?
    @NSManaged public var day: UInt16
    @NSManaged public var workTimeStart: String?
    @NSManaged public var workTimeEnd: String?
    @NSManaged public var launchTimeStart: String?
    @NSManaged public var launchTimeEnd: String?
    @NSManaged public var organization: Organization?

}
