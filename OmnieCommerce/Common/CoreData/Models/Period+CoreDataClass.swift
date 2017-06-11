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
        period.cellHeight = 44.0
        period.cellDivision = 1.0
        
        if (isDateNeedClear) {
            period.dateStart = Date() as NSDate
            period.dateEnd = Date() as NSDate
        }
    }
}
