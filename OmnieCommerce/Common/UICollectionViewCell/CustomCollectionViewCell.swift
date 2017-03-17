//
//  CustomCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

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
        self.name.text = category.name!
        self.imageView.image = UIImage.init(named: "image-no-organization")
        
        if let imagePath = category.imagePath {
            self.imageView.af_setImage(withURL: URL(string: "http://\(imagePath)")!,
                                       placeholderImage: UIImage.init(named: "image-no-organization"))
        }

        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        self.selectedBackgroundView = selectedView
    }
}
