//
//  TextFieldManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TextFieldManager: NSObject {
    // MARK: - Properties
    var textFieldsArray: [CustomTextField]!
    weak var currentVC: BaseViewController!
    
    
    // MARK: - Class Initialization
    init(withTextFields array: [CustomTextField]) {
        super.init()
        
        self.textFieldsArray = array
    }
    
    
    // MARK: - Custom Functions
    func didLoadNextTextField(afterCurrent textField: CustomTextField) {
        if (textField.tag == 99) {
            textField.resignFirstResponder()
        } else {
            let currentIndex = textFieldsArray.index(of: textField)!
            let nextIndex = textFieldsArray.index(after: currentIndex)
            
            textFieldsArray[nextIndex].becomeFirstResponder()
        }
    }
    
    func checkTextFieldCollection() -> Bool {
        // Check empty fields
        let emptyFields = textFieldsArray.filter({ $0.text?.isEmpty == true })
        
        guard emptyFields.count == 0 else {
            // TODO: - ADD ALERT
            currentVC.showAlertView(withTitle: "Info".localized(), andMessage: "All fields can be...".localized())
            
            return false
        }

        var results = [Bool]()
        
        for textField in textFieldsArray {
            switch textField.style! {
            case .Email:
                let result = textField.checkEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PhoneEmail:
                let result = textField.checkPhoneEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PasswordStrength:
                let result = textField.checkPasswordValidation(textField.text!)
                
                (result) ? (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint) : (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .Code:
                let result = textField.text == (currentVC as! EnterCodeShowViewController).enteredCode

                (result) ? (currentVC as! EnterCodeShowViewController).didHide((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint) : (currentVC as! EnterCodeShowViewController).didShow((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)
                
                results.append(result)

            default:
                break
            }
        }
        
        return results.reduce(true) { $0 && $1 }
    }
}


// MARK: - UITextFieldDelegate
extension TextFieldManager: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentVC?.selectedRange = textField.convert(textField.frame, to: currentVC?.view)

        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
        case .PasswordStrength:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
        case .Code:
            (currentVC as! EnterCodeShowViewController).didHide((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)
            
        default:
            break
        }

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Email:
            if !(textField as! CustomTextField).checkEmailValidation(textField.text!) {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneEmail:
            if !(textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PasswordStrength:
            if !((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            }
            
        case .Code:
            if (textField.text != (currentVC as! EnterCodeShowViewController).enteredCode) {
                (currentVC as! EnterCodeShowViewController).didShow((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)
            }
            
        default:
            break
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
        case .PasswordStrength:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
            (currentVC as! PasswordStrengthView).passwordStrengthView.passwordStrengthLevel = (string.isEmpty && textField.text?.characters.count == 1) ? .None : (textField as! CustomTextField).checkPasswordStrength(textField.text! + string)
            
            (currentVC as! PasswordStrengthView).passwordStrengthView.setNeedsDisplay()

        case .Code:
            (currentVC as! EnterCodeShowViewController).didHide((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)

            if (string.isEmpty) {
                return true
            }
            
            guard Int(string) != nil || ((textField.text?.isEmpty)! && string == "+") else {
                return false
            }
            
            if ((textField.text! + string).characters.count <= 4) {
                return true
            } else {
                return false
            }
            
        default:
            break
        }

        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)

        case .PasswordStrength:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
            (currentVC as! PasswordStrengthView).passwordStrengthView.passwordStrengthLevel = .None
            (currentVC as! PasswordStrengthView).passwordStrengthView.setNeedsDisplay()

        case .Code:
            (currentVC as! EnterCodeShowViewController).didHide((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)

        default:
            break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Email:
            if (textField as! CustomTextField).checkEmailValidation(textField.text!) {
                self.didLoadNextTextField(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneEmail:
            if (textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                self.didLoadNextTextField(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PasswordStrength:
            if ((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                self.didLoadNextTextField(afterCurrent: textField as! CustomTextField)
                
                return true
            } else {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
                
                return false
            }

        case .Code:
            if (textField.text == (currentVC as! EnterCodeShowViewController).enteredCode) {
                (currentVC as! EnterCodeShowViewController).didHide((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)
                
                textField.resignFirstResponder()
                
                return true
            } else {
                (currentVC as! EnterCodeShowViewController).didShow((currentVC as! EnterCodeShowViewController).codeErrorMessageView, withConstraint: (currentVC as! EnterCodeShowViewController).codeErrorMessageViewTopConstraint)

                return false
            }
            
        default:
            self.didLoadNextTextField(afterCurrent: textField as! CustomTextField)
        }
        
        return true
    }
}
