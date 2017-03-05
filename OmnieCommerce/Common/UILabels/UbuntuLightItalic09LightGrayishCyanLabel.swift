//
//  UbuntuLightItalic09LightGrayishCyanLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightItalic09LightGrayishCyanLabel: UILabel {
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
        textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.lightGrayishCyan
        textAlignment   =   .left
        
        self.adjustsFontSizeToFitWidth  =   true
        clipsToBounds   =   true
    }
}
