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
            return "\(monthsNames[components.month! - 1]) \(components.year!)".capitalized

        case .WeekdayMonthYear:
            dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
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
    
    func globalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        
        return Date(timeInterval: seconds, since: self)
    }
    
    func previousMonth() -> Date {
        var dateComponents = Calendar.current.dateComponents([.weekday, .month, .day, .year], from: self)
        
        if dateComponents.month == 0 {
            dateComponents.month = 11
            dateComponents.year! -= 1
        } else {
            dateComponents.month! -= 1
        }
        
        return Calendar.current.date(from: dateComponents)!
    }

    func previousDate() -> Date {
        return self.addingTimeInterval(TimeInterval.init(-24 * 60 * 60))
    }

    func nextMonth() -> Date {
        var dateComponents = Calendar.current.dateComponents([.weekday, .month, .day, .year], from: self)
        
        if dateComponents.month == 11 {
            dateComponents.month = 0
            dateComponents.year! += 1
        } else {
            dateComponents.month! += 1
        }
        
        return Calendar.current.date(from: dateComponents)!
    }

    func nextDate() -> Date {
        return self.addingTimeInterval(TimeInterval.init(24 * 60 * 60))
    }
}


