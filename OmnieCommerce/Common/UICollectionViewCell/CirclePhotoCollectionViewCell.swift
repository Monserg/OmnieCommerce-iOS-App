//
//  CirclePhotoCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

class CirclePhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageButton: BorderVeryDarkDesaturatedBlueButton!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerImageButtonTap(_ sender: BorderVeryDarkDesaturatedBlueButton) {
    }
}


// MARK: - ConfigureCell
extension CirclePhotoCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization = item as! Organization

        if let imagePath = organization.logoURL {
            imageButton.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath-\(indexPath.row)"), for: .normal,
                                    placeholder: UIImage.init(named: "image-no-organization"),
                                    options: [.transition(ImageTransition.fade(1)),
                                              .processor(ResizingImageProcessor(targetSize: imageButton.frame.size))],
                                    completionHandler: { image, error, cacheType, imageURL in
                                        self.imageButton.imageView?.kf.cancelDownloadTask()
            })
        } else {
            imageButton.setImage(UIImage.init(named: "image-no-photo"), for: .normal)
        }
    }
}
