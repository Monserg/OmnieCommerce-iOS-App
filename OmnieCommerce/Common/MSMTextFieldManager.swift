//
//  MSMMSMTextFieldManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTextFieldManager: NSObject {
    // MARK: - Properties
    var textFieldsArray: [CustomTextField]!
    var currentVC: BaseViewController!
    var firstResponder: CustomTextField!
    
    var handlerTextFieldCompletion: HandlerTextFieldCompletion?
    var handlerCleanReturnCompletion: HandlerPassDataCompletion?
    var handlerKeywordsFieldCompletion: HandlerSendButtonCompletion?
    var handlerFirstResponderCompletion: HandlerSendButtonCompletion?
    var handlerTextFieldShowErrorViewCompletion: HandlerTextFieldShowErrorViewCompletion?
    var handlerPhoneNumberLenghtCompletion: HandlerPassDataCompletion?
    
    // MARK: - Class Initialization
    init(withTextFields array: [CustomTextField]) {
        super.init()
        
        self.textFieldsArray = array
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func nextTextFieldDidLoad(afterCurrent textField: CustomTextField) {
        if (textField.tag == 99) {
            textField.resignFirstResponder()
        } else {
            var currentIndex = textFieldsArray!.index(of: textField)!
            var nextIndex = textFieldsArray!.index(after: currentIndex)
            
            while (textFieldsArray![nextIndex].isHidden) {
                currentIndex = nextIndex
                nextIndex = textFieldsArray!.index(after: currentIndex)
            }
            
            guard nextIndex <= textFieldsArray.count - 1 else {
                textField.resignFirstResponder()
                return
            }
            
            textFieldsArray![nextIndex].becomeFirstResponder()
        }
    }
    
    func checkTextFieldCollection() -> Bool {
        // Check empty fields
        let emptyFields = textFieldsArray!.filter({ $0.text?.isEmpty == true })
        
        guard emptyFields.count == 0 else {
            currentVC!.alertViewDidShow(withTitle: "Info", andMessage: "All fields can be...", completion: { _ in })
            
            return false
        }
        
        var results = [Bool]()
        
        for textField in textFieldsArray! {
            switch textField.style! {
            case .Email:
                let result = textField.checkEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PhoneEmail, .PhoneButton:
                let result = textField.checkPhoneEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .Password, .PasswordButton:
                let result = textField.checkPasswordValidation(textField.text!)
                
                (result) ? (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint) : (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PasswordStrength:
                let result = textField.checkPasswordValidation(textField.text!)
                
                (result) ? (currentVC as! PasswordStrengthErrorMessageView).didHide((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint) : (currentVC as! PasswordStrengthErrorMessageView).didShow((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
                
                results.append(result)
                                
            default:
                break
            }
        }
        
        return results.reduce(true) { $0 && $1 }
    }
}


// MARK: - UITextFieldDelegate
extension MSMTextFieldManager: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentVC?.selectedRange = textField.convert(textField.frame, to: currentVC?.view)
        firstResponder = textField as! CustomTextField
        
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail, .PhoneButton:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
        case .Phone:
            handlerFirstResponderCompletion!()
            (currentVC as! PhoneErrorMessageView).didHide((currentVC as! PhoneErrorMessageView).phoneErrorMessageView, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
            
        case .Password, .PasswordButton:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
        case .PasswordStrength:
            (currentVC as! PasswordStrengthErrorMessageView).didHide((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
            
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
            if !(textField as! CustomTextField).checkEmailValidation(textField.text!) && textField.tag != 0 {
                (currentVC as! EmailErrorMessageView).emailErrorMessageView.didShow(true, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .Phone:
            if !(textField as! CustomTextField).checkPhoneValidation(textField.text!) {
                (currentVC as! PhoneErrorMessageView).didShow((currentVC as! PhoneErrorMessageView).phoneErrorMessageView, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
            } else {
                handlerTextFieldCompletion!(textField as! CustomTextField, true)
            }
            
        case .PhoneEmail, .PhoneButton:
            if !(textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .Password, .PasswordButton:
            if !((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            } else if (textField.tag == 99) {
                handlerCleanReturnCompletion!(false)
            }
            
        case .PasswordStrength:
            if !((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                (currentVC as! PasswordStrengthErrorMessageView).didShow((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
                return false
            }
            
        case .Code:
            return true
            
        default:
            if ((textField as! CustomTextField).style! == .Name && textField.tag == 99) {
                handlerKeywordsFieldCompletion!()
            }
            
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        firstResponder = textField as! CustomTextField
        
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail:
            (currentVC as! EmailErrorMessageView).emailErrorMessageView.didShow(false, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
        case .PhoneButton, .Phone:
            // Delete character
            if (string.isEmpty) {
                (currentVC as! PhoneErrorMessageView).phoneErrorMessageView.didShow(false, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)                
                return true
            }
            
            // Show Phone Error Message View
            guard Int(string) != nil || string == "+" else {
                (currentVC as! PhoneErrorMessageView).phoneErrorMessageView.didShow(true, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
                return false
            }
            
            // Hide Phone Error Message View
            if let _ = Int(string) {
                (currentVC as! PhoneErrorMessageView).phoneErrorMessageView.didShow(false, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
                
                if ((textField as! CustomTextField).style! == .Phone && textField.text!.characters.count > 0) {
                    handlerPhoneNumberLenghtCompletion!(textField.text!.characters.count)
                }
                
                return true
            } else if ((textField.text?.isEmpty)! && string == "+") {
                return true
            } else {
                return false
            }

        case .Password, .PasswordButton:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
        case .PasswordRepeat:
            (currentVC as! RepeatPasswordErrorMessageView).didHide((currentVC as! RepeatPasswordErrorMessageView).repeatPasswordErrorMessageView, withConstraint: (currentVC as! RepeatPasswordErrorMessageView).repeatPasswordErrorMessageViewTopConstraint)
            
        case .PasswordStrength:
            (currentVC as! PasswordStrengthErrorMessageView).didHide((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
            
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
            
        case .PhoneButton, .Phone:
            (currentVC as! PhoneErrorMessageView).phoneErrorMessageView.didShow(false, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
            
        case .Password, .PasswordButton:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
        case .PasswordStrength:
            (currentVC as! PasswordStrengthErrorMessageView).didHide((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
            
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
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! EmailErrorMessageView).emailErrorMessageView.didShow(true, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneEmail:
            if (textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneButton, .Phone:
            if (textField as! CustomTextField).checkPhoneValidation(textField.text!) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! PhoneErrorMessageView).phoneErrorMessageView.didShow(true, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraint)
            }
            
        case .Password, .PasswordButton:
            if ((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
                
                return true
            } else if (textField.tag == 99) {
                handlerCleanReturnCompletion!(true)
                return false
            } else {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            }
            
        case .PasswordStrength:
            if ((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
                
                return true
            } else {
                (currentVC as! PasswordStrengthErrorMessageView).didShow((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
                
                return false
            }
            
        case .Code:
            textField.resignFirstResponder()
            return true
            
        default:
            self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
        }
        
        return true
    }
}
