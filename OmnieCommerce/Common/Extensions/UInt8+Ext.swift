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
        var ones = [String]()
        var zeros = [String]()
        
        for (index, count) in counts.enumerated() {
            let dayCode = self & count
            (dayCode > 0) ? ones.append(weekdayShort[index]) : zeros.append(weekdayShort[index])
        }
        
        if (ones.count == 1) {
            result = ones.first!
        } else if (ones.count > 1) {
            result = ones.first! + " - " + ones.last!
        }
        
//        else if (zeros.count > 0) {
//            result =
//        }
        
        return result
    }
}
