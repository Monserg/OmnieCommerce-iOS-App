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
    var cellHeight: CGFloat = 45.0

    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], andTimeSheet timesheet: TimeSheet) {
        // Prepare to save data
        self.timesheet = timesheet
        self.startString = json["start"] as! String
        self.startDate = self.startString.convertToDate(withDateFormat: .DiscountCardDate) as NSDate
        self.endString = json["end"] as! String
        self.endDate = self.endString.convertToDate(withDateFormat: .DiscountCardDate) as NSDate
        self.type = TimeSheetItemType.init(rawValue: (json["type"] as! String))
        
        self.codeID = "\(timesheet.codeID)-\((json["start"] as! String).components(separatedBy: "T").last!)"
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
