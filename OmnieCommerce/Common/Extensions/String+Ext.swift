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
    case ResponseDate           =   "MMM dd, yyyy HH:mm:ss a"           // "Nov 11, 2011 12:00:00 AM"
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
        dateFormatter.dateFormat = dateFormatType.rawValue
        
        return dateFormatter.date(from: self)!
    }
}
