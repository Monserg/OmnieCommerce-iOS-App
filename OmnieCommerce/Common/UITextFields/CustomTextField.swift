//
//  CustomTextField.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Navajo_Swift
import Localize_Swift

protocol NameTextField {
    func didApplyStyle()
}

@IBDesignable class CustomTextField: UITextField {
    // MARK: - Properties
    var attributedPlaceholderString: NSAttributedString!
    private var validator = NJOPasswordValidator.standardValidator
    
    
    // MARK: - Class Initialization
    func ddd() {
//        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init()))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0

        self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName:  UIFont.ubuntuLightItalic16, NSForegroundColorAttributeName: UIColor.darkCyan, NSKernAttributeName: 0.0, NSParagraphStyleAttributeName: paragraphStyle])
        
        self.font = (self.font?.pointSize == 12) ? UIFont.ubuntuLightItalic12 : UIFont.ubuntuLightItalic16
        self.textColor = UIColor.init(hexString: "#dedede", withAlpha: 1.0)
        self.tintColor = UIColor.init(hexString: "#dedede", withAlpha: 1.0)
        self.textAlignment = .left
        
        // Delegate
        self.delegate = TextFieldManager()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        ddd()
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Custom Functions
    func checkPasswordStrength(_ password: String) -> PasswordStrengthLevel {
        let strengthLevelString = Navajo.localizedString(for: Navajo.strength(of: password))
        var strengthLevel: PasswordStrengthLevel!
        
        switch strengthLevelString {
        case "Very Weak", "Weak":
            strengthLevel = .Weak
            
        case "Reasonable":
            strengthLevel = .Reasonable
            
        case "Strong", "Very Strong":
            strengthLevel = .Strong
            
        default:
            strengthLevel = .None
        }
        
        return strengthLevel
    }
    
    func checkPasswordValidation(_ password: String) -> Bool {
        let lengthRule = NJOLengthRule(min: 8, max: 24)
        validator = NJOPasswordValidator(rules: [lengthRule])
        
        if let failingRules = validator.validate(password) {
            var errorMessages: [String] =   []
            
            failingRules.forEach { rule in
                errorMessages.append(rule.localizedErrorDescription)
            }
            
            return false
        } else {
            return true
        }
    }
    
    func checkPhoneValidation(_ phone: String) -> Bool {
        // Validate Phone number
        guard !(phone.isEmpty) else {
            return true
        }
        
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phone.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        let resultPhone = phone == filtered
        
        print(object: "resultPhone = \(resultPhone)")
        
        return resultPhone
    }
    
    func checkEmailValidation(_ email: String) -> Bool {
        // Validate Email
        guard !(email.isEmpty) else {
            return false
        }
        
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let resultEmail = emailTest.evaluate(with: email)
        
        print(object: "resultEmail = \(resultEmail)")
        
        return resultEmail
    }
    
    func checkPhoneEmailValidation(_ text: String) -> Bool {
        return checkPhoneValidation(text) || checkEmailValidation(text)
    }
}


// MARK: - NameTextField protocol
extension CustomTextField: NameTextField {
    func didApplyStyle() {
        keyboardType = .default
    }
}
