//
//  DiscountCardCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher

@IBDesignable class DiscountCardCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UbuntuLightVeryLightGrayLabel!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - ConfigureCell
extension DiscountCardCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let discountCard = item as! DiscountCard
        
        self.name.text = discountCard.nameValue
        
        if let imageID = discountCard.imageID {
            imageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: imageID),
                                  placeholder: nil,
                                  options: [.transition(ImageTransition.fade(1)),
                                            .processor(ResizingImageProcessor(referenceSize: imageView.frame.size,
                                                                              mode: .aspectFill))],
                                  completionHandler: { image, error, cacheType, imageURL in
                                    self.imageView.kf.cancelDownloadTask()
            })
        } else {
            imageView.contentMode = .center
            
            UIView.animate(withDuration: 0.5, animations: { 
                self.imageView.backgroundColor = UIColor.veryDarkGrayishBlue38
                self.imageView.image = UIImage.init(named: "image-no-photo")
            })
        }
        
        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        self.selectedBackgroundView = selectedView
    }
}
