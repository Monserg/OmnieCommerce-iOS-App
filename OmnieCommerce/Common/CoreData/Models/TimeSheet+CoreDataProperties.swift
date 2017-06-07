//
//  TimeSheet+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension TimeSheet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeSheet> {
        return NSFetchRequest<TimeSheet>(entityName: "TimeSheet")
    }

    @NSManaged public var codeID: String
    @NSManaged public var date: String?
    @NSManaged public var workTimeStart: String
    @NSManaged public var workTimeEnd: String
    @NSManaged public var breakDuration: Int16
    @NSManaged public var orderDuration: Int32
    @NSManaged public var slotsCount: Int16
    @NSManaged public var minDuration: Bool
    @NSManaged public var timesheets: NSSet?

}

// MARK: Generated accessors for timesheets
extension TimeSheet {

    @objc(addTimesheetsObject:)
    @NSManaged public func addToTimesheets(_ value: TimeSheetItem)

    @objc(removeTimesheetsObject:)
    @NSManaged public func removeFromTimesheets(_ value: TimeSheetItem)

    @objc(addTimesheets:)
    @NSManaged public func addToTimesheets(_ values: NSSet)

    @objc(removeTimesheets:)
    @NSManaged public func removeFromTimesheets(_ values: NSSet)

}
