//
//  Date+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum StringDateStyle: String {
    case Date = "Date"
    case Time = "Time"
    case MonthYear = "MonthYear"
    case WeekdayMonthYear = "WeekdayMonthYear"
}

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
    
    func convertToString(withStyle dateStyle: StringDateStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        switch dateStyle {
        case .Date:
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
        case .Time:
            dateFormatter.dateFormat = "HH:mm"
            
        case .MonthYear:
            let components = Calendar.current.dateComponents([.weekday, .month, .day, .year], from: self)
            let monthsNames = Calendar.current.standaloneMonthSymbols
            dateFormatter.dateFormat = "\(monthsNames[components.month! - 1]) \(components.year!)"

        case .WeekdayMonthYear:
            dateFormatter.dateFormat = "EEEE dd MMMM YYYY"
        }
        
        return dateFormatter.string(from: self).capitalized
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
