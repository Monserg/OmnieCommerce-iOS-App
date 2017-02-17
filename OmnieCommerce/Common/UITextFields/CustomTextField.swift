//
//  CustomTextField.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

protocol NameTextField {
    func didApplyStyle()
}

@IBDesignable class CustomTextField: UITextField {
    // MARK: - Properties
    var attributedPlaceholderString: NSAttributedString!
    
    
    // MARK: - Class Initialization
    init() {
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init()))
        
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

    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        keyboardAppearance = (Config.Constants.isAppThemesLight) ? .dark : .light
    }    
}


// MARK: - NameTextField protocol
extension CustomTextField: NameTextField {
    func didApplyStyle() {
        keyboardType = .default
    }
}
