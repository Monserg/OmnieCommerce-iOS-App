//
//  UbuntuRegularVeryDarkGrayLabel.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuRegularVeryDarkGrayLabel: UILabel {
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
        font            =   (isLightColorAppSchema) ? UIFont.systemFont(ofSize: 12) : UIFont(name: "Ubuntu-Regular", size: font!.pointSize)!
        textColor       =   (isLightColorAppSchema) ? UIColor.white : UIColor.veryDarkGray
        textAlignment   =   textAlignment
        
        self.adjustsFontSizeToFitWidth  =   true
        clipsToBounds   =   true
    }
}
