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
        dateFormatter.locale = Locale.init(identifier: Locale.current.currencyCode!)
        var weekdayShort = dateFormatter.shortStandaloneWeekdaySymbols.map { $0.uppercaseFirst }
        let element = weekdayShort.remove(at: 0)
        weekdayShort.insert(element, at: weekdayShort.count)
        let counts: [UInt8] = [1, 2, 4, 8, 16, 32, 64]
        var result = String()
        
        for (index, count) in counts.enumerated() {
            let dayCode = self & count

            if (dayCode > 0 && index == 0) {
                result = weekdayShort[index]
            } else if (dayCode > 0 && index > 0 && !result.hasSuffix(" - ")) {
                result = result + " - "
            } else if (dayCode == 0 && index > 0) {
                result = result + ", "
            }
        }
        
        return result
    }
}
