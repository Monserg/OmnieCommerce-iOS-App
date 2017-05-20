//
//  HandbookTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher

class HandbookTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var phones: [String]?
    
    var handlerPhoneButtonTapCompletion: HandlerPassDataCompletion?
    var handlerBussinessCardButtonTapCompletion: HandlerPassDataCompletion?
    
    // Outlets
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var addressLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var phoneButton: FillVeryLightOrangeButton!
    @IBOutlet weak var cardButton: FillVeryLightOrangeButton!
    @IBOutlet weak var organizationImageView: CustomImageView!
    
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
    
    
    // MARK: - Actions
    @IBAction func handlerPhoneButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerPhoneButtonTapCompletion!(phones)
    }
    
    @IBAction func handlerCardButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerBussinessCardButtonTapCompletion!(sender)
    }
}


// MARK: - ConfigureCell
extension HandbookTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let handbook = item as! Handbook

        self.organizationNameLabel.text = handbook.name
        selectionStyle = .none

        if let phonesList = handbook.phones, phonesList.count > 0 {
            self.phones = phonesList
        } else {
            self.phoneButton.isHidden = true
        }
        
        if let addressString = handbook.address {
            self.addressLabel.text = addressString
        } else {
            self.addressLabel.isHidden = true
        }
        
        if let imageID = handbook.imageID {
            organizationImageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: imageID),
                                              placeholder: UIImage.init(named: "image-no-organization"),
                                              options: [.transition(ImageTransition.fade(1)),
                                                        .processor(ResizingImageProcessor(referenceSize: organizationImageView.frame.size,
                                                                                          mode: .aspectFill))],
                                              completionHandler: { image, error, cacheType, imageURL in
                                                self.organizationImageView.kf.cancelDownloadTask()
            })
        } else {
            organizationImageView.image = UIImage.init(named: "image-no-organization")
        }
    }
}
