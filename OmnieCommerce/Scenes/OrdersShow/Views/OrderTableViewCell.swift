//
//  OrderTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher

class OrderTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var orderID: String!
    
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var serviceNameLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalicLightGrayishCyanLabel!

    // Outlets
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var stateButton: BorderTitleButton!
    
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
extension OrderTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let order = item as! Order
        
//        orderID = order.codeID
//        nameLabel.text = organization.name ?? "XXX"
//        cityLabel.text = organization.addressCity ?? "XXX"
//        streetLabel.text = organization.addressStreet ?? "XXX"
//        //        ratingView.rating = organization.rating!
//        isFavorite = organization.isFavorite
//        selectionStyle = .none
//        
//        favoriteButton.setImage((isFavorite) ?  UIImage(named: "image-favorite-star-selected") :
//            UIImage(named: "image-favorite-star-normal"), for: .normal)
//        
//        if let imagePath = organization.logoURL {
//            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: organizationID),
//                                      placeholder: UIImage.init(named: "image-no-organization"),
//                                      options: [.transition(ImageTransition.fade(1)),
//                                                .processor(ResizingImageProcessor(referenceSize: logoImageView.frame.size,
//                                                                                  mode: .aspectFill))],
//                                      completionHandler: { image, error, cacheType, imageURL in
//                                        self.logoImageView.kf.cancelDownloadTask()
//            })
//        } else {
//            logoImageView.image = UIImage.init(named: "image-no-organization")
//        }
    }
}
