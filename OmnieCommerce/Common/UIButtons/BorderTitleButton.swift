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
            let titleText = (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
            
            if (isAppThemeDark) {
                backgroundColor = UIColor.white
            } else {
                backgroundColor = UIColor.init(hexString: "#24323f", withAlpha: 1.0)
            }
            
            switch titleOriginal {
            case "CONFIRMED BY USER", "CONFIRMED BY ADMIN", "DONE":
                tintColor = (isAppThemeDark) ? UIColor.black : UIColor.darkCyan
                titleLabel?.font = (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic09
                borderColor = (isAppThemeDark) ? UIColor.black : UIColor.darkCyan
                
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.darkCyan]), for: .normal)
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.darkCyanAlpha30]), for: .highlighted)

            default:
                tintColor = (isAppThemeDark) ? UIColor.black : UIColor.yellow
                titleLabel?.font = (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuLightItalic09
                borderColor = (isAppThemeDark) ? UIColor.black : UIColor.darkCyan
                
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyan]), for: .normal)
                setAttributedTitle(NSAttributedString(string: titleText, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayishCyanAlpha30]), for: .highlighted)
            }
            
            layer.borderWidth = 1
            layer.cornerRadius = frame.height / 2
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            clipsToBounds = true
        }
    }
}
