//
//  UbuntuLightVeryLightOrangeLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightSoftOrangeLabel: UILabel {
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
        font            =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont(name: "Ubuntu-Light", size: font!.pointSize)!
        textColor       =   (isAppThemeDark) ? UIColor.white : UIColor.softOrange
        textAlignment   =   textAlignment
        
        self.adjustsFontSizeToFitWidth = true
        clipsToBounds   =   true
    }
}
