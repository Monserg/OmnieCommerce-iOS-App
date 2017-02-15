//
//  CustomTextField.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

@IBDesignable class CustomTextField: UITextField {
    // MARK: - Properties
    var attributedPlaceholderString: NSAttributedString!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    // MARK: - Custom Functions
    func setup() {
//        guard fieldType != "None" else {
//            return
//        }
        
        // Setup design

    }
}
