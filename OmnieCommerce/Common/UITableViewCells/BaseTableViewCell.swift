//
//  BaseTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

enum CellStyle: String {
    case News           =   "News"
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
    var isCellFavorite  =   false
    var handlerFavoriteButtonCompletion: HandlerSendButtonCompletion?
    var item: Any!
    
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
    func setup(withItem item: Any) {
        self.item                               =   item

        switch item {
        case is News:
            let news                            =   item as! News
            nameLabel.text                      =   news.title
            dateLabel.text                      =   news.activeDate.convertToString(withStyle: .Date)
            describeLabel.numberOfLines         =   2
            describeLabel.text                  =   news.description
            describeLabel.clipsToBounds         =   false
            
            logoImageView.af_setImage(withURL: URL(string: news.logoStringURL ?? "https://omniesoft.ua/")!,
                                      placeholderImage: UIImage.init(named: "image-no-photo"),
                                      filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))

        case is Message:
            let message                         =   item as! Message
            nameLabel.text                      =   message.title
            messageLabel.text                   =   message.text
            dateLabel.text                      =   message.activeDate.convertToString(withStyle: (message.activeDate.isActiveToday()) ? .Time : .Date)
            
            logoImageView.af_setImage(withURL: URL(string: message.logoStringURL ?? "https://omniesoft.ua/")!,
                                      placeholderImage: UIImage.init(named: "image-no-photo"),
                                      filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))

            if (message.isOwn) {
                userAvatarImageView.isHidden    =  false
                
                userAvatarImageView.af_setImage(withURL: URL(string: message.userAvatarStringURL ?? "https://omniesoft.ua/")!,
                                                placeholderImage: UIImage.init(named: "image-no-user"),
                                                filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: userAvatarImageView.frame.size, radius: userAvatarImageView.frame.size.width / 2))
            } else {
                userAvatarImageView.isHidden    =  true
            }
            
        default:
            break
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        isCellFavorite  =   !isCellFavorite
        
        favoriteButton.setImage((isCellFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        handlerFavoriteButtonCompletion!()
    }
}
