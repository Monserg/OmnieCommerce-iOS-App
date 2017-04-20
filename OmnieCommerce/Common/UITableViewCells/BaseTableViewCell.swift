//
//  BaseTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos

enum CellStyle: String {
    case Avatar         =   "Avatar"
    case News           =   "NewsCell"
    case Order          =   "Order"
    case Message        =   "Message"
    case Profile        =   "Profile"
    case Service        =   "Service"
    case Handbook       =   "Handbook"
    case Favourite      =   "Favourite"
    case Organization   =   "Organization"
}

@IBDesignable class BaseTableViewCell: UITableViewCell {
    // MARK: - Properties
    var isFavorite      =   false
    var handlerFavoriteButtonCompletion: HandlerSendButtonCompletion?
    
    @IBOutlet weak var borderDottedView: DottedBorderView!
    
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var describeLabel: CustomLabel!
    @IBOutlet weak var messageLabel: CustomLabel!
    @IBOutlet weak var cityLabel: CustomLabel!
    @IBOutlet weak var streetLabel: CustomLabel!

    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var userAvatarImageView: CustomImageView!

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!
   
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBInspectable var cellStyle: String = ""

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Custom Functions
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        switch item {
        case is Organization:
            let organization                    =   item as! Organization
            nameLabel.text                      =   organization.name
//            cityLabel.text                      =   organization.addressCity!
//            streetLabel.text                    =   organization.addressStreet!
//            ratingView.rating                   =   organization.rating!
            isFavorite                          =   organization.isFavorite
            
            favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)

//            logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
//                                      placeholderImage: UIImage.init(named: "image-no-organization"),
//                                      filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
            
            dottedBorderView.style              =   (indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
            
        default:
            break
        }
        
        selectionStyle                          =   .none
    }
    
    
    // MARK: - Actions
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        isFavorite = !isFavorite
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        handlerFavoriteButtonCompletion!()
    }
}
