//
//  CustomImageView.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomImageView: UIImageView {
    // MARK: - Properties
    @IBInspectable var isCircle: Bool = false {
        didSet {
            layer.cornerRadius = (isCircle) ? frame.height / 2 : 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    

    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print(object: "\(type(of: self)): \(#function) run. Button frame = \(self.frame)")
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {}
}
