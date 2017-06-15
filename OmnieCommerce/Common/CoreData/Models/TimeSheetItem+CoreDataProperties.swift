//
//  TimeSheetItem+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension TimeSheetItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeSheetItem> {
        return NSFetchRequest<TimeSheetItem>(entityName: "TimeSheetItem")
    }

    @NSManaged public var codeID: String
    @NSManaged public var endDate: NSDate
    @NSManaged public var endString: String
    @NSManaged public var startDate: NSDate
    @NSManaged public var startString: String
    @NSManaged public var typeValue: String
    @NSManaged public var timesheet: TimeSheet?

}
