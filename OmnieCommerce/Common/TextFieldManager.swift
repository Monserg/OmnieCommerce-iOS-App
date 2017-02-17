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
    var selectedRange: CGRect?
    
    
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
}


// MARK: - UITextFieldDelegate
extension TextFieldManager: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField as! CustomTextField).style! {
        case .Name, .Password:
            self.didLoadNextTextField(afterCurrent: textField as! CustomTextField)
                    
        default:
            break
        }
        
        
        
        return true
    }
}
