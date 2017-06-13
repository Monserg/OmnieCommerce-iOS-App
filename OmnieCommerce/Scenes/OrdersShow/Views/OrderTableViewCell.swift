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
    
    
    // MARK: - Outlets
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var serviceNameLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalicLightGrayishCyanLabel!

    // Outlets
    @IBOutlet weak var organizationImageView: CustomImageView!
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
        
        orderID = order.codeID
        organizationNameLabel.text = order.organizationName
        serviceNameLabel.text = order.serviceName
        dateLabel.text = (order.dateStart as Date).convertToString(withStyle: .DateDot)
        selectionStyle = .none
        
        // Modify state button
        stateButton.titleOriginal = order.status

        if let imageID = order.imageID {
            organizationImageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: "\(orderID)-\(imageID)"),
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
