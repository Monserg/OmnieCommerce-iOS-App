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
public class TimeSheetItem: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    var type: TimeSheetItemType! {
        set {
            self.typeValue = newValue.rawValue
        }
        
        get {
            return TimeSheetItemType.init(rawValue: self.typeValue)
        }
    }
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "TimeSheetTableViewCell"
    var cellHeight: CGFloat = 90.0

    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], andTimeSheet timesheet: TimeSheet) {
        // Prepare to save data
        self.timesheet = timesheet
        self.start = json["start"] as! String
        self.end = json["end"] as! String
        self.type = TimeSheetItemType.init(rawValue: (json["type"] as! String))
        
        self.codeID = "\(timesheet.codeID)-\(start.components(separatedBy: "T").first!)"
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
