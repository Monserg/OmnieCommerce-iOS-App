//
//  UbuntuLightItalicModerateRedLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightItalicModerateRedLabel: UILabel {
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
        font            =   UIFont(name: "Ubuntu-LightItalic", size: font!.pointSize)!
        textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.moderateRed
        textAlignment   =   textAlignment
        
        self.adjustsFontSizeToFitWidth  =   true
        clipsToBounds   =   true
    }
}
