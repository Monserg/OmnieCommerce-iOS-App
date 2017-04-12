//
//  ReviewCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ReviewCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var handlerPageButtonTapCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var userNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var userRatingView: CosmosView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UbuntuLightItalicVeryLightGrayLabel! {
        didSet {
            noteLabel.numberOfLines = 4
            noteLabel.lineBreakMode = .byTruncatingTail
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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPageButtonTap(_ sender: UIButton) {
        // tag = 0 (left), tag = 2 (right)
        handlerPageButtonTapCompletion!(sender)
    }
}


// MARK: - ConfigureCell
extension ReviewCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let value = item as! String
        userNameLabel.text = "\(value) \(indexPath.row)"
//        let galleryImage = item as! GalleryImage
//        
//        if let imagePath = galleryImage.imagePath {
//            imageButton.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath-\(indexPath.row)"), for: .normal,
//                                    placeholder: UIImage.init(named: "image-no-photo"),
//                                    options: [.transition(ImageTransition.fade(1)),
//                                              .processor(ResizingImageProcessor(targetSize: imageButton.frame.size,
//                                                                                contentMode: .aspectFit))],
//                                    completionHandler: { image, error, cacheType, imageURL in
//                                        self.imageButton.imageView?.kf.cancelDownloadTask()
//            })
//        } else {
//            imageButton.setImage(UIImage.init(named: "image-no-photo"), for: .normal)
//        }
    }
}
