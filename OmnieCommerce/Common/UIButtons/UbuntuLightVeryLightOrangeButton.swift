//
//  UbuntuLightVeryLightOrangeButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightVeryLightOrangeButton: UIButton {
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        tintColor           =   UIColor.veryLightOrange
        let titleText       =   (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
        titleLabel?.font    =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 9) : UIFont(name: "Ubuntu-Light", size: (titleLabel?.font!.pointSize)!)
        
        setTitle(titleText, for: .normal)
        setTitleColor(UIColor.veryLightOrange, for: .normal)

        borderColor         =   UIColor.clear
        borderWidth         =   0
        clipsToBounds       =   true
    }
}
