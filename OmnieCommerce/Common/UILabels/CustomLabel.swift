
//
//  CustomLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

@IBDesignable class CustomLabel: UILabel {
    // MARK: - Properties
    enum Types {
        case title
        case standard
    }
    
    @IBInspectable var style: CGFloat = 0 {
        didSet {
            self.text = self.text?.localized()
            
            switch style {
            case 1:
                self.font = Config.Labels.Fonts.helveticaNeueCyrLight32
                self.textColor = Config.Labels.Colors.veryLightGray
                
            default:
                self.font = UIFont.systemFont(ofSize: 13.0)
                self.textColor = UIColor.red
            }
            
            self.adjustsFontSizeToFitWidth = true
        }
    }
}
