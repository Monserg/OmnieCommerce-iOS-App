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
    case ForgotPassword = "ForgotPassword"
    case Congratulations = "Congratulations"
    case CategoryName = "CategoryName"
    case Date = "Date"
    case DateItalic = "DateItalic"
    case Describe = "Describe"
    case Message = "Message"
    case FromTo = "FromTo"
    case CalendarWeekday = "CalendarWeekday"
    case BarCodeTitle = "BarCodeTitle"
    case ActionViewTitle = "ActionViewTitle"
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
        
        switch labelStyle {
        case .Error:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic12
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.moderateRed
            
        case .Title:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrLight32
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightGray
            
        case .Copyright:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.darkCyan
            text = "\u{00A9} Omniesoft, 2016"
            
        case .MenuItem:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight16
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightGray
            
        case .ForgotPassword:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrThin33
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightGray
            
        case .Congratulations:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.helveticaNeueCyrThin47
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightGray
            
        case .CategoryName:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryDarkGray

        case .Date:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight09
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryDarkGrayishBlue53

        case .DateItalic:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryDarkGrayishBlue53

        case .Describe:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic12
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.lightGrayishCyan
            
        case .Message:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.lightGrayishCyan
            
        case .FromTo:
            attributedText = (Config.Constants.isAppThemesLight) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312)
            
        case .CalendarWeekday:
            attributedText = (Config.Constants.isAppThemesLight) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightDarkCyan16)
            
        case .BarCodeTitle:
            attributedText = (Config.Constants.isAppThemesLight) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.ubuntuLightVeryLightGray16)

        case .ActionViewTitle:
            attributedText = (Config.Constants.isAppThemesLight) ? NSAttributedString(string: text!, attributes: UIFont.ubuntuLightItalicVeryDarkGrayishBlue5312) : NSAttributedString(string: text!, attributes: UIFont.helveticaNeueCyrLightVeryLightGray21)

        default:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLight12
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightGray
        }
        
        self.adjustsFontSizeToFitWidth = true
    }
}
