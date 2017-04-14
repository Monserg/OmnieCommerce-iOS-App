//
//  CategoryCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UbuntuRegularVeryDarkGrayLabel!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - ConfigureCell
extension CategoryCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let category = item as! Category
        self.name.text = category.name!
        
        if let imagePath = category.imagePath {
            imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: category.codeID),
                                  placeholder: UIImage.init(named: "image-no-photo"),
                                  options: [.transition(ImageTransition.fade(1)),
                                            .processor(ResizingImageProcessor(referenceSize: imageView.frame.size, mode: .aspectFit))],
                                  completionHandler: { image, error, cacheType, imageURL in
                                    self.imageView.kf.cancelDownloadTask()
            })
        } else {
            imageView.image = UIImage.init(named: "image-no-photo")
        }
        
        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        self.selectedBackgroundView = selectedView
    }
}
