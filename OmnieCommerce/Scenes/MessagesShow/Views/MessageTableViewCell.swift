//
//  MessageTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

@IBDesignable class MessageTableViewCell: UITableViewCell {
    // MARK: - Properties    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var messageLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var userAvatarImageView: CustomImageView!
    
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
extension MessageTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let message = item as! Message
        nameLabel.text = message.name
        messageLabel.text = message.text
        dateLabel.text = message.activeDate.convertToString(withStyle: (message.activeDate.isActiveToday()) ? .Time : .Date)
        selectionStyle = .none

        if let imagePath = message.logoStringURL {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                                      placeholder: UIImage.init(named: "image-no-photo"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor(targetSize: logoImageView.frame.size,
                                                                                  contentMode: .aspectFit))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-photo")
        }
        
        dottedBorderView.style = .AroundDottedRectangle
        
        if (message.isOwn) {
            userAvatarImageView.isHidden = false
            userAvatarImageView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: 20, height: 20))
            
            if let imagePath = message.logoStringURL {
                logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath),
                                          placeholder: UIImage.init(named: "image-no-user"),
                                          options: [.transition(ImageTransition.fade(1)),
                                                    .processor(ResizingImageProcessor(targetSize: logoImageView.frame.size,
                                                                                      contentMode: .aspectFit))],
                                          completionHandler: { image, error, cacheType, imageURL in
                                            self.logoImageView.kf.cancelDownloadTask()
                })
            } else {
                logoImageView.image = UIImage.init(named: "image-no-user")
            }
        } else {
            userAvatarImageView.isHidden = true
        }
    }
}
