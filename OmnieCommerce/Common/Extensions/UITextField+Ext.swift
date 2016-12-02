//
//  UITextField+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum TextFieldStyle: String {
    case darkCyan = "DarkCyan"
    case grayishBlue = "GrayishBlue"
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
            self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : UIColor.grayishBlue, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
            
            self.font = Config.Fonts.ubuntuLightItalic16
            self.textColor = UIColor.grayishBlue
            self.tintColor = UIColor.grayishBlue
            
        case .darkCyan:
            attributedPlaceholder = NSAttributedString(string: (placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : UIColor.darkCyan, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
            
            font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuLightItalic16
            textColor = (Config.Constants.isAppThemesLight) ? UIColor.blue : UIColor.darkCyan
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.blue : UIColor.darkCyan
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
    }
}

