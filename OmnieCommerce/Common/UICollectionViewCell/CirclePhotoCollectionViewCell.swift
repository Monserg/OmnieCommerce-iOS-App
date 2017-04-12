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
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
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
        let galleryImage = item as! GalleryImage
        imageButton.frame = CGRect.init(origin: .zero, size: CGSize.init(width: galleryImage.cellHeight, height: galleryImage.cellHeight))

        if let imagePath = galleryImage.imagePath {
            imageButton.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath-\(indexPath.row)"), for: .normal,
                                    placeholder: UIImage.init(named: "image-no-photo"),
                                    options: [.transition(ImageTransition.fade(1)),
                                              .processor(ResizingImageProcessor(targetSize: imageButton.frame.size,
                                                                                contentMode: .aspectFit))],
                                    completionHandler: { image, error, cacheType, imageURL in
                                        self.imageButton.imageView?.kf.cancelDownloadTask()
            })
        } else {
            imageButton.setImage(UIImage.init(named: "image-no-photo"), for: .normal)
        }
    }
}
