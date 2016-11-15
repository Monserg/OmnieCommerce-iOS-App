
//
//  CustomLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    // MARK: - Properties
    enum Types {
        case title
        case standard
    }
    
    var type = Types.standard
    
    
    // MARK: - Custom Functions
    func setup(withType type: Types) {
        switch type {
        case .title:
            self.font = Config.Labels.Fonts.helveticaNeueCyrLight32
            self.textColor = Config.Labels.Colors.veryLightGray
            
        default:
            self.font = UIFont.systemFont(ofSize: 13.0)
            self.textColor = UIColor.red
        }
    }
}
