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
    enum TextColorTypes: CGFloat {
        case grayishBlue = 0.0
        case darkCyan = 1.0
    }
    
    @IBInspectable var textColorType: CGFloat = TextColorTypes.grayishBlue.rawValue {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = 0
            
            switch textColorType {
            // darkCyan = 1.0
            case 1.0:
                self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Colors.darkCyan!, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
                
                self.font = Config.Fonts.ubuntuLightItalic16
                self.textColor = Config.Colors.darkCyan
                self.tintColor = Config.Colors.darkCyan
                changeClearButtonColor()
                
            // grayishBlue = 0.0
            default:
                self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Colors.grayishBlue!, NSKernAttributeName : 0.0, NSParagraphStyleAttributeName : paragraphStyle])
                
                self.font = Config.Fonts.ubuntuLightItalic16
                self.textColor = Config.Colors.grayishBlue
                self.tintColor = Config.Colors.grayishBlue
                changeClearButtonColor()
            }
            
            attributedPlaceholderText = self.attributedPlaceholder
        }
    }
    
    var attributedPlaceholderText: NSAttributedString!
    
    
    // MARK: - Class initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Custom Functions
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
}
