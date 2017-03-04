//
//  String+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

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
    
    func convertToDate() -> Date {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   "dd.MM.yyyy"
        
        return dateFormatter.date(from: self)!
    }    
}
