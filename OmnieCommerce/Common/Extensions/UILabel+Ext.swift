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
    case Copyright = "Copyright"
    case MenuItem = "MenuItem"
    case DateItalic = "DateItalic"
    case Message = "Message"
    case FromTo = "FromTo"
    case CalendarWeekday = "CalendarWeekday"
    case BarCodeTitle                                   =   "BarCodeTitle"
    case ActionViewTitle                                =   "ActionViewTitle"
    case UbuntuRegular16VeryDarkGray                    =   "UbuntuRegular16VeryDarkGray"
    case UbuntuRegular21SoftOrange                      =   "UbuntuRegular21SoftOrange"
    case UbuntuLightItalic12VerySoftRed                 =   "UbuntuLightItalic12VerySoftRed"
    case UbuntuLightItalic12LightGrayishCyan            =   "UbuntuLightItalic12LightGrayishCyan"
    case UbuntuLight12VeryLightGray                     =   "UbuntuLight12VeryLightGray"
    case UbuntuLight09VeryDarkGrayishBlue53             =   "UbuntuLight09VeryDarkGrayishBlue53"
    case UbuntuLight12SoftOrange                        =   "UbuntuLight12SoftOrange"
    case UbuntuLight16VeryLightGray                     =   "UbuntuLight16VeryLightGray"
    case HelveticaNeueCyrThin47VeryLightGray            =   "HelveticaNeueCyrThin47VeryLightGray"
    case HelveticaNeueCyrLight21VeryLightGray           =   "HelveticaNeueCyrLight21VeryLightGray"
    case HelveticaNeueCyrLight32VeryLightGray           =   "HelveticaNeueCyrLight32VeryLightGray"
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
        text                =   text?.localized()
        textAlignment       =   .center
        
        switch labelStyle {
        case .Error:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : ((font!.pointSize == 12) ? UIFont.ubuntuLightItalic12 : UIFont.ubuntuLightItalic10)
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.moderateRed
            textAlignment   =   .left
            
        case .Copyright:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.darkCyan
            text            =   "\u{00A9} Omniesoft, 2016"
            
        case .MenuItem:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight16
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
            textAlignment   =   .left
            
        case .DateItalic:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGrayishBlue53

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

        case .UbuntuRegular16VeryDarkGray:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGray

        case .UbuntuRegular21SoftOrange:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular21
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.softOrange
            textAlignment   =   .left

        case .UbuntuLightItalic12VerySoftRed:
            font            =   UIFont.ubuntuLightItalic12
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dc8181" : "#8b0000", withAlpha: 1.0)
            textAlignment   =   .left

        case .UbuntuLightItalic12LightGrayishCyan:
            font            =   UIFont.ubuntuLightItalic12
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dc8181" : "#cce8e8", withAlpha: 1.0)
            textAlignment   =   .left
            
        case .UbuntuLight12VeryLightGray:
            font            =   UIFont.ubuntuLight12
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dedede" : "#dedede", withAlpha: 1.0)
            textAlignment   =   .left

        case .UbuntuLight09VeryDarkGrayishBlue53:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGrayishBlue53
            textAlignment   =   .left
            
        case .UbuntuLight12SoftOrange:
            font            =   UIFont.ubuntuLight12
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dedede" : "#f5cf68", withAlpha: 1.0)
            textAlignment   =   .left
            
        case .UbuntuLight16VeryLightGray:
            font            =   UIFont.ubuntuLight16
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dedede" : "#dedede", withAlpha: 1.0)
            textAlignment   =   .left
            
        case .HelveticaNeueCyrThin47VeryLightGray:
            font            =   UIFont.helveticaNeueCyrThin47
            textColor       =   UIColor(hexString: (isAppThemeDark) ? "#dedede" : "#dedede", withAlpha: 1.0)

        case .HelveticaNeueCyrLight21VeryLightGray:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrLight21
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
            textAlignment   =   .left

        case .HelveticaNeueCyrLight32VeryLightGray:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrLight32
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
            
        default:
            font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight12
            textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
        }
        
        self.adjustsFontSizeToFitWidth = true
    }
}
