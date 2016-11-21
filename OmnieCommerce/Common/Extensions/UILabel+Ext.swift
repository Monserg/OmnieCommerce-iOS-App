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
    case Title = "Title"
    case Copyright = "Copyright"
    case MenuItem = "MenuItem"
    case Congratulations = "Congratulations"
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
        case .Title:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.helveticaNeueCyrLight32
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.veryLightGray
            
        case .Copyright:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuLight9
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.darkCyan
            text = "\u{00A9} Omniesoft, 2016"
            
        case .MenuItem:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuLight16
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.veryLightGray
            
        case .Congratulations:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.helveticaNeueCyrThin47
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.veryLightGray
            
        default:
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuLight12
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.veryLightGray
        }
        
        self.adjustsFontSizeToFitWidth = true
    }
}
