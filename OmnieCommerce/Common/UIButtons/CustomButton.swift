//
//  CustomButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    // MARK: - Properties
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
}
