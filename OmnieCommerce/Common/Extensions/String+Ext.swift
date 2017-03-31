//
//  String+Ext.swift
//  OmnieCommerce
//
//  http://nsdateformatter.com
//
//
//  Created by msm72 on 07.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case Default                =   "dd.MM.yyyy"                        // "17.03.2017"
    case ResponseDate           =   "yyyy-MM-dd"                        // "2017-03-17"
    case NewsDate               =   "yyyy-MM-dd HH:mm"                  // "2017-03-31 01:03"
}

extension String {
    // MARK: - Properties
    var first: String {
        return String(characters.prefix(1))
    }
    
    var last: String {
        return String(characters.suffix(1))
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }


    // MARK: - Custom Functions
    func verticalStyle(string: String) -> String {
        var text = [Character]()
        
        for char in string.characters {
            text.append(char)
            text.append("\n")
        }
        
        return String(text)
    }
    
    func convertToDate(withDateFormat dateFormatType: DateFormatType) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = dateFormatType.rawValue
        
        return dateFormatter.date(from: self)!
    }
}
