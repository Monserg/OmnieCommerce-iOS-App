//
//  TimeSheetItem+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension TimeSheetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeSheetItem> {
        return NSFetchRequest<TimeSheetItem>(entityName: "TimeSheetItem")
    }

    @NSManaged public var typeValue: String
    @NSManaged public var start: String
    @NSManaged public var end: String
    @NSManaged public var timesheet: TimeSheet?

}
