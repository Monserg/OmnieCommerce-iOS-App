//
//  UITextField+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
/*
enum FieldType: String {
    case None           =   "None"
    case Name           =   "Name"
    case Password       =   "Password"
    case Phone          =   "Phone"
    case Email          =   "Email"
    case PhoneEmail     =   "PhoneEmail"
}

extension UITextField {
    // MARK: - Properties
    @IBInspectable var fieldType: String? {
        set { setupWithTypeNamed(newValue) }
        get { return nil }
    }

    
    // MARK: - Custom Functions
    func setupWithTypeNamed(_ named: String?) {
        if let typeName = named, let fieldType = FieldType(rawValue: typeName) {
            setupWithType(fieldType)
        }
    }
    
    func setupWithType(_ fieldType: FieldType) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0

        // Text design: Ubuntu-Light, 12 or 16, #dedede
        font = (Config.Constants.isAppThemesDark) ? UIFont.systemFont(ofSize: 12) : ((font?.pointSize == 12) ? UIFont.ubuntuLight12 : UIFont.ubuntuLight16)
        textColor = (Config.Constants.isAppThemesDark) ? UIColor.blue : UIColor.veryLightGray
        tintColor = (Config.Constants.isAppThemesDark) ? UIColor.blue : UIColor.veryLightGray
        keyboardAppearance = (Config.Constants.isAppThemesDark) ? .dark : .light

        // Placeholder design
        attributedPlaceholder = NSAttributedString(string: (placeholder?.localized())!, attributes: [NSFontAttributeName:  (font?.pointSize == 12) ? UIFont.ubuntuLightItalic12 : UIFont.ubuntuLightItalic16, NSForegroundColorAttributeName: UIColor.darkCyan, NSKernAttributeName: 0.0, NSParagraphStyleAttributeName: paragraphStyle])
        
        
        // Keyboards & any other settings
        switch fieldType {
        // Name
        case .Name:
            print(object: #function)

            
        // Password
        case .Password:
            print(object: #function)
            
            
        // Phone
        case .Phone:
            print(object: #function)
            
            
        // Email
        case .Email:
            print(object: #function)
            
            
        // PhoneEmail:
        case .PhoneEmail:
            print(object: #function)
            
            
        default:
            break
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
    
    func validateEmailPhone(_ value: String) -> Bool {
        // Validate Email
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let resultEmail = emailTest.evaluate(with: value)
        
        // Validate Phone number
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = value.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        let resultPhone = value == filtered

        print(object: "resultEmail = \(resultEmail) and resultPhone = \(resultPhone)")
        
        return resultEmail || resultPhone
    }
}
*/
