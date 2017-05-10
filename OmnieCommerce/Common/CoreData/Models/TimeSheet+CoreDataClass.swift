//
//  TimeSheet+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(TimeSheet)
public class TimeSheet: NSManagedObject {
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], forDate date: String) {
        guard let workTimeStart = json["start"] as? String, let workTimeEnd = json["end"] as? String, let breakDuration = json["breakDuration"] as? Int16, let slotsCount = json["slotsCount"] as? Int16, let minDuration = json["minDuration"] as? Bool else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let timeSheetEntity = CoreDataManager.instance.entityForName("TimeSheet") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: timeSheetEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save data
        self.date = date
        self.workTimeStart = workTimeStart
        self.workTimeEnd = workTimeEnd
        self.breakDuration = breakDuration
        self.slotsCount = slotsCount
        self.minDuration = minDuration
        
        if let items = json["timesheet"] as? NSArray, items.count > 0 {
            for index in 0..<(items.firstObject as! NSArray).count {
                let dictionary = (items.firstObject as! NSArray)[index]
                self.addToTimesheets(TimeSheetItem.init(json: dictionary as! [String : AnyObject], andTimeSheet: self)!)
            }
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
