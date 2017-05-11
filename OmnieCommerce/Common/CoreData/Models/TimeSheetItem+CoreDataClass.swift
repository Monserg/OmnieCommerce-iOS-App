//
//  TimeSheetItem+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

enum TimeSheetItemType: String {
    case Close  =   "CLOSE"
    case Order  =   "ORDER"
    case Free   =   "FREE"
}

@objc(TimeSheetItem)
public class TimeSheetItem: NSManagedObject {
    var type: TimeSheetItemType! {
        set {
            self.typeValue = newValue.rawValue
        }
        
        get {
            return TimeSheetItemType.init(rawValue: self.typeValue)
        }
    }
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andTimeSheet timesheet: TimeSheet) {
        guard let start = json["start"] as? String, let end = json["end"] as? String, let type = json["type"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let timeSheetItemEntity = CoreDataManager.instance.entityForName("TimeSheetItem") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: timeSheetItemEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save data
        self.timesheet = timesheet
        self.start = start
        self.end = end
        self.type = TimeSheetItemType.init(rawValue: type)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
