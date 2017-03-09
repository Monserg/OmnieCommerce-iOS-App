//
//  Date+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum StringDateStyle: String {
    case Date               =   "Date"
    case Time               =   "Time"
    case MonthYear          =   "MonthYear"
    case WeekdayMonthYear   =   "WeekdayMonthYear"
}

extension Date {
    func getDaysInMonth() -> [[String]] {
        let currentYear     =   Calendar.current.dateComponents([.year], from: self).year!
        var daysInMonth     =   [[String]]()
        
        for month in 1..<13 {
            let dateComponents  =   DateComponents(year: currentYear, month: month)
            let date            =   Calendar.current.date(from: dateComponents)!
            let range           =   Calendar.current.range(of: .day, in: .month, for: date)!
            let daysCount       =   range.count + 1
            
            
            
            
            
//            let dateComponents  =   DateComponents(timeZone: TimeZone.current, year: Calendar.current.component(.year, from: self), month: month)
//            let date            =   Calendar.current.date(from: dateComponents)!
//            let range           =   Calendar.current.range(of: .day, in: .month, for: date)!
//            let daysCount       =   range.count + 1
            
            var days            =   [String]()
            
            for day in 1..<daysCount {
                days.append(String(day))
            }
            
            daysInMonth.append(days)
        }
    
        return daysInMonth
    }
    
    func getMonthsNumbers() -> [String] {
        var months          =   [String]()
        
        for i in 1..<13 {
            months.append(String(i))
        }
        
        return months
    }
    
    func getYears() -> [String] {
        let currentYear     =   Calendar.current.dateComponents([.year], from: self).year!
        var years           =   [String]()
        
        for year in (currentYear - 5)..<(currentYear + 6) {
            years.append(String(year))
        }
        
        return years
    }
    
    func convertToString(withStyle dateStyle: StringDateStyle) -> String {
        let dateFormatter       =   DateFormatter()
        dateFormatter.locale    =   NSLocale.current
        
        switch dateStyle {
        case .Date:
            dateFormatter.dateFormat    =   "dd.MM.yyyy"
            
        case .Time:
            dateFormatter.dateFormat    =   "HH:mm"
            
        case .MonthYear:
            let components              =   Calendar.current.dateComponents([.weekday, .month, .day, .year], from: self)
            let monthsNames             =   Calendar.current.standaloneMonthSymbols
            dateFormatter.dateFormat    =  "\(monthsNames[components.month! - 1]) \(components.year!)"

        case .WeekdayMonthYear:
            dateFormatter.dateFormat    =   "EEEE dd MMMM YYYY"
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
        let timeZone    =   TimeZone.current
        let seconds     =   TimeInterval(timeZone.secondsFromGMT(for: self))
        
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
    
    func isLeapYear() -> Bool {
        let calendar    =   NSCalendar.current
        let components  =   calendar.dateComponents([.year], from: self)
        let year        =   components.year!
        let isLeapYear  =   ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        
        return isLeapYear
    }
}


