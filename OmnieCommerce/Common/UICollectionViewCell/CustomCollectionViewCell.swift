//
//  CustomCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: CustomLabel!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
    }
    
    
    // MARK: - Custom Functions
    func didSetup(withCategory category: Category) {
        self.imageView.image            =   UIImage.init(named: category.icon)
        self.name.text                  =   category.title
        
        // Set selected color
        let selectedView                =   UIView.init(frame: self.frame)
        selectedView.backgroundColor    =   UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        
        self.selectedBackgroundView     =   selectedView
    }
}
