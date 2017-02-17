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
    var selectedRange: CGRect?
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
        print(#function)
        return true
    }
}
