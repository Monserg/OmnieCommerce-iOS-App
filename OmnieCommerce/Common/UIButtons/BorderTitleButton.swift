//
//  BorderTitleButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class BorderTitleButton: UIButton {
    // MARK: - Properties
    var titleOriginal: String! {
        didSet {
            titleLabel!.text = titleOriginal
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        if (titleOriginal != nil) {
            let titleText = "      \(titleOriginal.localized())      "
            
            if (isLightColorAppSchema) {
                backgroundColor = UIColor.white
            } else {
                backgroundColor = UIColor.init(hexString: "#24323f", withAlpha: 1.0)
            }
            
            switch titleOriginal {
            case "CONFIRMED BY USER", "CONFIRMED BY ADMIN", "DONE":
                tintColor = (isLightColorAppSchema) ? UIColor.black : UIColor.darkCyan
                titleLabel?.font = (isLightColorAppSchema) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic09
                borderColor = (isLightColorAppSchema) ? UIColor.black : UIColor.darkCyan
                
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.darkCyan]), for: .normal)
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.darkCyanAlpha30]), for: .highlighted)

            case "PENDING FOR USER", "PENDING FOR ADMIN":
                tintColor = (isLightColorAppSchema) ? UIColor.black : UIColor.veryLightGray
                titleLabel?.font = (isLightColorAppSchema) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic09
                borderColor = (isLightColorAppSchema) ? UIColor.black : UIColor.veryLightGray
                
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.veryLightGray]), for: .normal)
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.veryLightGrayAlpha30]), for: .highlighted)

            default:
                tintColor = (!isLightColorAppSchema) ? UIColor.black : UIColor.yellow
                titleLabel?.font = (!isLightColorAppSchema) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic09
                borderColor = (!isLightColorAppSchema) ? UIColor.black : UIColor.darkCyan
                
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyan]), for: .normal)
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyanAlpha30]), for: .highlighted)
            }


            layer.borderWidth = 1
            layer.cornerRadius = frame.height / 2
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            clipsToBounds = true
            sizeToFit()
        }
    }
}
