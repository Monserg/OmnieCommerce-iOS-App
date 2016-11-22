//
//  UITextField+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum TextFieldStyle: String {
    case grayishBlue = "GrayishBlue"
    case darkCyan = "DarkCyan"
}


extension UITextField {
    // MARK: - Properties
    @IBInspectable var textFieldStyle: String? {
        set { setupWithStyleNamed(newValue) }
        get { return nil }
    }

    
    // MARK: - Custom Functions
    func setupWithStyleNamed(_ named: String?) {
        if let styleName = named, let textFieldStyle = TextFieldStyle(rawValue: styleName) {
            setupWithStyle(textFieldStyle)
        }
    }
    
    func setupWithStyle(_ textFieldStyle: TextFieldStyle) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0

        switch textFieldStyle {
        case .grayishBlue:
            self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Colors.grayishBlue!, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
            
            self.font = Config.Fonts.ubuntuLightItalic16
            self.textColor = Config.Colors.grayishBlue
            self.tintColor = Config.Colors.grayishBlue
            
        case .darkCyan:
            attributedPlaceholder = NSAttributedString(string: (placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Colors.darkCyan!, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
            
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuLightItalic16
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.blue : Config.Colors.darkCyan
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.blue : Config.Colors.darkCyan
        }
        
        changeClearButtonColor()
    }
    
    func changeClearButtonColor() {
        // Change clear button color
        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            
            // Finally, set the image color
            clearButton.tintColor = self.tintColor
        }
    }
}

