
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
        case congratulations
    }
    
    @IBInspectable var style: CGFloat = 0 {
        didSet {
            self.text = self.text?.localized()
            
            switch style {
            // title = 1
            case 1:
                self.font = Config.Fonts.helveticaNeueCyrLight32
                self.textColor = Config.Colors.veryLightGray
                
            // copyright = 2
            case 2:
                self.font = Config.Fonts.ubuntuLight9
                self.textColor = Config.Colors.darkCyan
                self.text = "\u{00A9} Omniesoft, 2016"
                
            // menuItem = 3
            case 3:
                self.font = Config.Fonts.ubuntuLight16
                self.textColor = Config.Colors.veryLightGray

            // congratulations = 4
            case 4:
                self.font = Config.Fonts.helveticaNeueCyrThin47
                self.textColor = Config.Colors.veryLightGray

            // standard = 0
            default:
                self.font = Config.Fonts.ubuntuLight12
                self.textColor = Config.Colors.veryLightGray
            }
            
            self.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    // MARK: - Class initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
