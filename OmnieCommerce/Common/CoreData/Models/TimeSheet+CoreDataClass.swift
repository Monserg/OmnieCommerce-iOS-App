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
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forService serviceID: String, andDate date: String) {
        // Prepare to save data
        self.date = date
        self.workTimeStart = json["start"] as! String
        self.workTimeEnd = json["end"] as! String
        self.breakDuration = json["breakDuration"] as! Int16
        self.slotsCount = json["slotsCount"] as! Int16
        self.minDuration = json["minDuration"] as! Bool

        self.codeID = "\(serviceID)-\(date)"

        if let items = json["timesheet"] as? NSArray, items.count > 0 {
            for index in 0..<(items.firstObject as! NSArray).count {
                if let jsonTimeSheetItem = (items.firstObject as? NSArray)?[index] as? [String: AnyObject] {
                    let start = jsonTimeSheetItem["start"] as? String
                    let end = jsonTimeSheetItem["end"] as? String
                    
                    if (start != nil && end != nil) {
                        let codeID = "\(self.codeID)-\(start!)-\(end!)"
                        
                        if let timeSheetItem = CoreDataManager.instance.entityBy("TimeSheetItem", andCodeID: codeID) as? TimeSheetItem {
                            timeSheetItem.profileDidUpload(json: jsonTimeSheetItem, andTimeSheet: self)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
