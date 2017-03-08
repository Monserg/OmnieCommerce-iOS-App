//
//  BorderVeryLightOrangeButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class BorderVeryLightOrangeButton: UIButton {
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        let titleText       =   (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
        
        setTitle(titleText, for: .normal)
        setTitle(titleText, for: .highlighted)

        if (isAppThemeDark) {
            backgroundColor =   UIColor.white
        } else {
            setBackgroundImage(UIImage(named: "image-background-color-very-dark-desaturated-blue-normal.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        tintColor           =   (isAppThemeDark) ? UIColor.black : UIColor.veryLightGray
        titleLabel?.font    =   (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
        borderColor         =   (isAppThemeDark) ? UIColor.black : UIColor.veryLightOrange

        layer.borderWidth   =   1
        layer.cornerRadius  =   frame.height / 2
        clipsToBounds       =   true
        
        guard imageView?.image != nil, titleLabel?.text != nil else {
            return
        }
        
        titleEdgeInsets     =   UIEdgeInsetsMake(0, 0, 0, 10)
        imageEdgeInsets     =   UIEdgeInsetsMake(0, (titleLabel?.frame.maxX)! + 0, 0, 0)
    }
}
