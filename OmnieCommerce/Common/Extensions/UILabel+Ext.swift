//
//  UILabel+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 21.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum LabelStyle: String {
    case Standard = "Standard"
    case Error = "Error"
    case Title = "Title"
    case Copyright = "Copyright"
    case MenuItem = "MenuItem"
    case CategoryName = "CategoryName"
    case Date = "Date"
    case DateItalic = "DateItalic"
    case Describe = "Describe"
    case Message = "Message"
    case FromTo = "FromTo"
    case CalendarWeekday = "CalendarWeekday"
    case BarCodeTitle                                   =   "BarCodeTitle"
    case ActionViewTitle                                =   "ActionViewTitle"
    case UbuntuLightItalic12VerySoftRed                 =   "UbuntuLightItalic12VerySoftRed"
    case HelveticaNeueCyrThin47VeryLightGray            =   "HelveticaNeueCyrThin47VeryLightGray"
}


extension UILabel {
    @IBInspectable var labelStyle: String? {
        set { setupWithStyleNamed(newValue) }
        get { return nil }
    }
    
    func setupWithStyleNamed(_ named: String?) {
        if let styleName = named, let labelStyle = LabelStyle(rawValue: styleName) {
            setupWithStyle(labelStyle)
        }
    }
    
    func setupWithStyle(_ labelStyle: LabelStyle) {
        text = text?.localized()
        textAlignment       =   .center
        
        switch labelStyle {
        case .Error:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : ((font!.pointSize == 12) ? UIFont.ubuntuLightItalic12 : UIFont.ubuntuLightItalic10)
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.moderateRed
            textAlignment   =   .left
            
        case .Title:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrLight32
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
            
        case .Copyright:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.darkCyan
            text            =   "\u{00A9} Omniesoft, 2016"
            
        case .MenuItem:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight16
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
            textAlignment   =   .left
            
        case .CategoryName:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGray

        case .Date:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGrayishBlue53

        case .DateItalic:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGrayishBlue53

        case .Describe:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic12
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.lightGrayishCyan
            
        case .Message:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.lightGrayishCyan
            
        case .FromTo:
            attributedText  =   (isAppThemeDark) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312)
            
        case .CalendarWeekday:
            attributedText  =   (isAppThemeDark) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightDarkCyan16)
            
        case .BarCodeTitle:
            attributedText  =   (isAppThemeDark) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightVeryLightGray16)

        case .ActionViewTitle:
            attributedText  =   (isAppThemeDark) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.helveticaNeueCyrLightVeryLightGray21)

        case .UbuntuLightItalic12VerySoftRed:
            font            =   UIFont.ubuntuLightItalic12
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dc8181" : "#8b0000", withAlpha: 1.0)
            textAlignment   =   .left

        case .HelveticaNeueCyrThin47VeryLightGray:
            font            =   UIFont.helveticaNeueCyrThin47
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dedede" : "#dedede", withAlpha: 1.0)

        default:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight12
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
        }
        
        self.adjustsFontSizeToFitWidth = true
    }
}
