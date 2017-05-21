//
//  BorderVeryLightOrangeButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class BorderVeryDarkDesaturatedBlueButton: UIButton {
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        let titleText = (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
        
        backgroundColor = (isLightColorAppSchema) ? UIColor.white : UIColor.init(hexString: "#273745", withAlpha: 1.0)
        tintColor = (isLightColorAppSchema) ? UIColor.black : UIColor.lightGrayishCyan
        titleLabel?.font = (isLightColorAppSchema) ? UIFont.systemFont(ofSize: 09) : UIFont.ubuntuLightItalic09
        borderColor = (isLightColorAppSchema) ? UIColor.black : UIColor.init(hexString: "#1d2a37", withAlpha: 1.0)

        setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyan]), for: .normal)
        setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyanAlpha30]), for: .highlighted)

        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        
//        let leghtTitle = Double(titleLabel!.text!.characters.count) * 7.5
//        self.frame = CGRect.init(origin: frame.origin, size: CGSize.init(width: CGFloat(leghtTitle), height: frame.height))

        clipsToBounds = true
        
        guard imageView?.image != nil, titleLabel?.text != nil else {
            return
        }
        
        imageEdgeInsets = UIEdgeInsetsMake(0, (titleLabel?.frame.maxX)! + 0, 0, 0)
    }
}
