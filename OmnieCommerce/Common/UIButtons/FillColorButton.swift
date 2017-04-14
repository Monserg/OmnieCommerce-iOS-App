//
//  FillColorButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class FillColorButton: UIButton {
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        let titleText = (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()

        setTitle(titleText, for: .normal)
        setTitle(titleText, for: .highlighted)

        if (backgroundColor == nil) {
            if (isAppThemeDark) {
                backgroundColor = UIColor.white
            } else {
                setBackgroundImage(UIImage(named: "image-background-color-very-light-orange-normal.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        borderColor = UIColor.clear
        borderWidth = 0
        
        (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal) :
                            setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuRegularVeryDarkGray16), for: .normal)
        
        (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted) :
                            setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuRegularVeryDarkGray16), for: .highlighted)
        
        titleLabel?.sizeToFit()

        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
        guard imageView?.image != nil, titleLabel?.text != nil else {
            return
        }
        
        titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        imageEdgeInsets = UIEdgeInsetsMake(0, (titleLabel?.frame.maxX)! + 0, 0, 0)
    }
}
