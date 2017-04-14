//
//  UInt8+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

extension UInt8 {
    func convertToScheduleString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: Locale.current.languageCode!.lowercased())
        var weekdayShort = dateFormatter.shortStandaloneWeekdaySymbols.map { $0.uppercaseFirst }
        let element = weekdayShort.remove(at: 0)
        weekdayShort.insert(element, at: weekdayShort.count)
        let counts: [UInt8] = [1, 2, 4, 8, 16, 32, 64]
        var result = String()
        var hitch = [String]()
        var comma = [String]()
        var lastIndex = 0
        
        for (index, count) in counts.enumerated() {
            let dayCode = self & count
            
            if (dayCode > 0) {
                (index - lastIndex == 1) ? hitch.append(weekdayShort[index]) : comma.append(weekdayShort[index] + ", ")
                lastIndex = index
            }
        }
        
        if (hitch.count > 0 && comma.count > 0) {
            comma.append(contentsOf: hitch.map { $0 + ", "})
            result = comma.reduce(result, { $0 + $1 })
            result = result.substring(to: result.index(result.endIndex, offsetBy: -2))
        } else if (hitch.count == 1) {
            result = hitch.first!
        } else if (hitch.count > 1) {
            result = hitch.first! + " - " + hitch.last!
        } else if (comma.count == 1) {
            result = comma.first!
        } else if (comma.count > 0) {
            result = comma.reduce(result, { $0 + $1 })
            result = result.substring(to: result.index(result.endIndex, offsetBy: -2))
        }
        
        return result
    }
    
    func convertToUnitString() -> String? {
        switch self {
        case 0:
            return "грн/год"
        
        default:
            break
        }
        
        return nil
    }
}
