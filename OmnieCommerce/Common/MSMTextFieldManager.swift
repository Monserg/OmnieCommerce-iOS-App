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
    
    var handlerTextFieldCompletion: HandlerTextFieldCompletion?
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    var handlerTextFieldShowErrorViewCompletion: HandlerTextFieldShowErrorViewCompletion?
    
    // MARK: - Class Initialization
    init(withTextFields array: [CustomTextField]) {
        super.init()
        
        self.textFieldsArray    =   array
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func nextTextFieldDidLoad(afterCurrent textField: CustomTextField) {
        if (textField.tag == 99) {
            textField.resignFirstResponder()
        } else {
            let currentIndex    =   textFieldsArray!.index(of: textField)!
            let nextIndex       =   textFieldsArray!.index(after: currentIndex)
            
            textFieldsArray![nextIndex].becomeFirstResponder()
        }
    }
    
    func checkTextFieldCollection() -> Bool {
        // Check empty fields
        let emptyFields         =   textFieldsArray!.filter({ $0.text?.isEmpty == true })
        
        guard emptyFields.count == 0 else {
            currentVC!.alertViewDidShow(withTitle: "Info".localized(), andMessage: "All fields can be...".localized())
            
            return false
        }
        
        var results = [Bool]()
        
        for textField in textFieldsArray! {
            switch textField.style! {
            case .Email:
                let result      =   textField.checkEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PhoneEmail, .PhoneButton:
                let result      =   textField.checkPhoneEmailValidation(textField.text!)
                
                (result) ? (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint) : (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .Password, .PasswordButton:
                let result      =   textField.checkPasswordValidation(textField.text!)
                
                (result) ? (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint) : (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
                
                results.append(result)
                
            case .PasswordStrength:
                let result      =   textField.checkPasswordValidation(textField.text!)
                
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
        
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail, .PhoneButton:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
            // Hide/Show Delete Button
            if let textFieldNew = (textField as? CustomTextField), textFieldNew.style! == .PhoneButton {
                handlerTextFieldCompletion!(textFieldNew, (textFieldNew.text?.isEmpty)! ? true : false)
            }

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
            if !(textField as! CustomTextField).checkEmailValidation(textField.text!) {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneEmail, .PhoneButton:
            if !(textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .Password, .PasswordButton:
            if !((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            }
            
        case .PasswordStrength:
            if !((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                (currentVC as! PasswordStrengthErrorMessageView).didShow((currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageView, withConstraint: (currentVC as! PasswordStrengthErrorMessageView).passwordStrengthErrorMessageViewTopConstraint)
            }
            
        case .Code:
            return true
            
        default:
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Email, .PhoneEmail:
            (currentVC as! EmailErrorMessageView).didHide((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            
        case .PhoneButton:
            // Show/hide Delete button
            handlerTextFieldCompletion!(textField as! CustomTextField, (textField.text?.characters.count == 1 && string.isEmpty) ? true : false)
            
            // Delete character
            if (string.isEmpty) {
                handlerTextFieldShowErrorViewCompletion!(textField as! CustomTextField, false)
                return true
            }
            
            // Add New Phone View
            if (textField.text?.characters.count == 3 && !string.isEmpty) {
                if let _ = Int(string) {
                    handlerPassDataCompletion!(textField)
                    return true
                } else {
                    return false
                }
            }
            
            // Show Phone Error Message View
            guard Int(string) != nil || ((textField.text?.isEmpty)! && string == "+") else {
                handlerTextFieldShowErrorViewCompletion!(textField as! CustomTextField, true)
                return false
            }
            
            // Hide Phone Error Message View
            if let _ = Int(string) {
                handlerTextFieldShowErrorViewCompletion!(textField as! CustomTextField, false)
                return true
            } else {
                return false
            }

        case .Password, .PasswordButton:
            (currentVC as! PasswordErrorMessageView).didHide((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
            
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
            
        case .PhoneButton:
            let phoneErrorView      =   (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewsCollection.first(where: { $0.tag == textField.tag} )!
            let phoneErrorViewIndex =   (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewsCollection.index(of: phoneErrorView)!
            
            (currentVC as! PhoneErrorMessageView).didHide(phoneErrorView, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraintsCollection[phoneErrorViewIndex])
            
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
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneEmail:
            if (textField as! CustomTextField).checkPhoneEmailValidation(textField.text!) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
            } else {
                (currentVC as! EmailErrorMessageView).didShow((currentVC as! EmailErrorMessageView).emailErrorMessageView, withConstraint: (currentVC as! EmailErrorMessageView).emailErrorMessageViewTopConstraint)
            }
            
        case .PhoneButton:
            if (textField as! CustomTextField).checkPhoneValidation(textField.text!) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
            } else {
                let phoneErrorView      =   (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewsCollection.first(where: { $0.tag == textField.tag} )!
                let phoneErrorViewIndex =   (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewsCollection.index(of: phoneErrorView)!
                
                (currentVC as! PhoneErrorMessageView ).didShow(phoneErrorView, withConstraint: (currentVC as! PhoneErrorMessageView).phoneErrorMessageViewTopConstraintsCollection[phoneErrorViewIndex])
            }
            
        case .Password, .PasswordButton:
            if ((textField as! CustomTextField).checkPasswordValidation(textField.text!)) {
                self.nextTextFieldDidLoad(afterCurrent: textField as! CustomTextField)
                
                return true
            } else {
                (currentVC as! PasswordErrorMessageView).didShow((currentVC as! PasswordErrorMessageView).passwordErrorMessageView, withConstraint: (currentVC as! PasswordErrorMessageView).passwordErrorMessageViewTopConstraint)
                
                return false
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
