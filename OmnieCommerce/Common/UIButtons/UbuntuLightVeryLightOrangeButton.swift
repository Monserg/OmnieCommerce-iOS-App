//
//  UbuntuLightVeryLightOrangeButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class UbuntuLightVeryLightOrangeButton: UIButton {
    // MARK: - Properties
    @IBInspectable var isTitleUnderlined: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        guard attributedTitle(for: .normal) != nil else {
            return
        }
        
        tintColor = UIColor.veryLightOrange
        let titleText = (isTitleUnderlined) ? attributedTitle(for: .normal)!.string : (titleLabel?.text!.localized())!
        
        setAttributedTitle(NSAttributedString(string: titleText,
                                              attributes:   [ NSFontAttributeName: (!isLightColorAppSchema ? UIFont.systemFont(ofSize: 9) : UIFont(name: "Ubuntu-Light", size: titleLabel!.font!.pointSize)!),
                                                              NSForegroundColorAttributeName: UIColor.veryLightOrange,
                                                              NSUnderlineStyleAttributeName: (isTitleUnderlined ? NSUnderlineStyle.styleSingle.rawValue : NSUnderlineStyle.styleNone.rawValue)
                                                            ]),
                           for: .normal)
        
        borderColor = UIColor.clear
        borderWidth = 0
        clipsToBounds = true
    }
}
