//
//  Date+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

extension Date {
    func convertToDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func convertToTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
    
    func isActiveToday() -> Bool {
        // MARK: - Properties
        var isToday = false
        let today = NSDate()
        
        if (today.compare(self) == .orderedSame) {
            isToday = true
        }

        return isToday
    }
}
