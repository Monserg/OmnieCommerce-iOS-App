//
//  UbuntuLightItalicDarkCyanButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightItalicDarkCyanButton: UIButton {
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        tintColor = UIColor.darkCyan
        let titleText = (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
        titleLabel?.font = (isLightColorAppSchema) ? UIFont.systemFont(ofSize: 12) : UIFont(name: "Ubuntu-LightItalic", size: (titleLabel?.font!.pointSize)!)
        
        setTitle(titleText, for: .normal)
        setTitleColor(UIColor.darkCyan, for: .normal)

        borderColor = UIColor.clear
        borderWidth = 0
        clipsToBounds = true
    }
}
