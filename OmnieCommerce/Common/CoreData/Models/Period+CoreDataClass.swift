//
//  Period+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Period)
public class Period: NSManagedObject {
    // MARK: - Custom Functions
    func propertiesDidClear(withDate isDateNeedClear: Bool) {
        period.hourStart = 0
        period.minuteStart = 0
        period.hourEnd = 0
        period.minuteEnd = 0
        period.workHourStart = 0
        period.workHourEnd = 23
        period.workMinuteStart = 0
        period.workMinuteEnd = 0
        period.scale = 1
        period.cellHeight = 64.0
        
        if (isDateNeedClear) {
            period.dateStart = Date() as NSDate
            period.dateEnd = Date() as NSDate
        }
    }
}
