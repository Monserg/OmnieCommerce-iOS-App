//
//  NewsDataTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

class NewsDataTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var dateLabel: UbuntuLightVeryDarkGrayishBlueLabel!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!

    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: - ConfigureCell
extension NewsDataTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let newsData = item as! NewsData
        
        organizationNameLabel.text = newsData.organizationName
        dateLabel.text = (newsData.activeDate as Date).convertToString(withStyle: .DateDot)
        titleLabel.numberOfLines = 2
        titleLabel.text = newsData.title
        titleLabel.clipsToBounds = false
        selectionStyle = .none
        
        if let imageID = newsData.imageID {
            let imageURL = URL.init(string: MSMRestApiManager.instance.imageHostURL.absoluteString.appending("/retriew/?objectId=\(imageID)&imageType='SMALL'"))

            logoImageView.kf.setImage(with: ImageResource(downloadURL: imageURL!, cacheKey: "imagePath-\(indexPath.row)"),
                                      placeholder: UIImage.init(named: "image-no-organization"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor.init(referenceSize: logoImageView.frame.size,
                                                                                       mode: .aspectFill))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-organization")
        }
        
        dottedBorderView.style = .AroundDottedRectangle
    }
}
