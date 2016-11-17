
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
    enum Types: Int {
        case standard = 0
        case title
        case copyright
        case menuItem
    }
    
    @IBInspectable var style: CGFloat = 0 {
        didSet {
            self.text = self.text?.localized()
            
            switch style {
            // title = 1
            case 1:
                self.font = Config.Labels.Fonts.helveticaNeueCyrLight32
                self.textColor = Config.Labels.Colors.veryLightGray
                
            // copyright = 2
            case 2:
                self.font = Config.Labels.Fonts.ubuntuLight9
                self.textColor = Config.Labels.Colors.darkCyan
                self.text = "\u{00A9} Omniesoft, 2016"
                
            // menuItem = 3
            case 3:
                self.font = Config.Labels.Fonts.ubuntuLight16
                self.textColor = Config.Labels.Colors.veryLightGray

            // standard = 0
            default:
                self.font = UIFont.systemFont(ofSize: 13.0)
                self.textColor = UIColor.red
            }
            
            self.adjustsFontSizeToFitWidth = true
        }
    }
}
