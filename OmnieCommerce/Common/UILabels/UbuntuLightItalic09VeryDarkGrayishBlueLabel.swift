//
//  UbuntuLightItalic09VeryDarkGrayishBlueLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightItalic09VeryDarkGrayishBlueLabel: UILabel {
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
        font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont.ubuntuLightItalic09
        textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.veryDarkGrayishBlue53
        textAlignment   =   .right
        
        self.adjustsFontSizeToFitWidth  =   true
        clipsToBounds   =   true
    }
}
