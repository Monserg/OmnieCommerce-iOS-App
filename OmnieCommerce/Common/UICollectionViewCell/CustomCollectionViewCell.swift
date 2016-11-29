//
//  CustomCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomCollectionViewCell: UICollectionViewCell {
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print(object: "\(type(of: self)): \(#function) run. Button frame = \(self.frame)")
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Button rect = \(rect)")
    }
}
