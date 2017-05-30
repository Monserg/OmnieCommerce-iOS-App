//
//  BusinessCardTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher

class BusinessCardTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var businessCardID: String!
    
    // Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var emailLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    @IBOutlet weak var phoneLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    @IBOutlet weak var commentLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    
    @IBOutlet weak var dottedBorderView: DottedBorderView! {
        didSet {
            dottedBorderView.style = .AroundDottedRectangle
        }
    }

    
    // MARK: - Class Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: - ConfigureCell
extension BusinessCardTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let businessCard = item as! BusinessCard
        
        businessCardID = businessCard.codeID
        organizationNameLabel.text = businessCard.name ?? "Zorro"
        selectionStyle = .none
        
        if let email = businessCard.email {
            emailLabel.text = email
        } else {
            emailLabel.isHidden = true
        }
        
        if let comment = businessCard.comment {
            commentLabel.text = comment
        } else {
            commentLabel.isHidden = true
        }
        
        if let phones = businessCard.phones, phones.count > 0 {
            phoneLabel.text = phones.first!
        } else {
            phoneLabel.isHidden = true
        }
        
        if let imageID = businessCard.imageID {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Medium, inMode: .Get), cacheKey: imageID),
                                      placeholder: nil,
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor(referenceSize: logoImageView.frame.size,
                                                                                  mode: .aspectFill))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.contentMode = .center
            
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImageView.backgroundColor = UIColor.veryDarkGrayishBlue38
                self.logoImageView.image = UIImage.init(named: "image-no-organization")
            })
        }
        
        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        self.selectedBackgroundView = selectedView
    }
}
