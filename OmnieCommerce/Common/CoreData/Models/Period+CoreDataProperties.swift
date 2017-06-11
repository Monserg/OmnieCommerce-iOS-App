//
//  Period+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var additionalServicesDuration: Float
    @NSManaged public var codeID: String
    @NSManaged public var dateEnd: NSDate
    @NSManaged public var dateStart: NSDate
    @NSManaged public var hourEnd: Int16
    @NSManaged public var hourStart: Int16
    @NSManaged public var minuteEnd: Int16
    @NSManaged public var minuteStart: Int16
    @NSManaged public var serviceDuration: Float
    @NSManaged public var cellHeight: Float

}
