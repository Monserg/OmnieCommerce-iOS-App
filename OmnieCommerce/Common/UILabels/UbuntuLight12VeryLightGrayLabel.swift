//
//  UbuntuLight12VeryLightGrayLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLight12VeryLightGrayLabel: UILabel {
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        didSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        didSetup()
    }
    
    
    // MARK: - Custom Functions
    func didSetup() {
        text            =   text?.localized()
        font            =   UIFont.ubuntuLight12
        textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryLightGray
        textAlignment   =   .left
        
        self.adjustsFontSizeToFitWidth  =   true
        clipsToBounds   =   true
    }
}
