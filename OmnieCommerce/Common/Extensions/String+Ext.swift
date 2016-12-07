//
//  String+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

extension String {
    func verticalStyle(string: String) -> String {
        var text = [Character]()
        
        for char in string.characters {
            text.append(char)
            text.append("\n")
        }
        
        return String(text)
    }
}
