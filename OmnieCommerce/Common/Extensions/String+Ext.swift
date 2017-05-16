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
    case PriceDate              =   "MMM dd, yyyy HH:mm:ss a"           // "May 9, 2017 12:01:14 PM"
    case BirthdayDate           =   "MMM dd, yyyy"                      // "Dec 14, 2014"
    case RegistrationDate       =   "yyyy-MM-dd HH:mm:ss"               // "2017-05-10 10:11:11.108985"
}

enum ImageSize: String {
    case Small                  =   "SMALL"
    case Medium                 =   "MEDIUM"
    case Original               =   "ORIGINAL"
}

enum ImageMode: String {
    case Get                    =   "/retriew/"
    case Upload                 =   "/upload/"
    case Delete                 =   "/delete/"
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
    
    func convertToURL(withSize size: ImageSize, inMode mode: ImageMode) -> URL {
        switch mode {
        case .Get:
            return URL.init(string: MSMRestApiManager.instance.imageHostURL.absoluteString.appending("\(mode.rawValue)?objectId=\(self)&imageType=SMALL"))!

        case .Upload:
            return URL.init(string: MSMRestApiManager.instance.imageHostURL.absoluteString.appending(mode.rawValue))!

        case .Delete:
            return URL.init(string: MSMRestApiManager.instance.imageHostURL.absoluteString.appending("\(mode.rawValue)?objectId=\(self)"))!
        }
    }
    
    // For Schedule
    func twoNumberFormat() -> String {
        switch Int(self)! {
        case 0...9:
            return "0\(Int(self)!)"
            
        default:
            return self
        }
    }
}
