//
//  OrganizationTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

class OrganizationTableViewCell: UITableViewCell {
    // MARK: - Properties
    var isFavorite      =   false
    var handlerFavoriteButtonCompletion: HandlerSendButtonCompletion?
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var cityLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var streetLabel: UbuntuLightItalicLightGrayishCyanLabel!
    
    @IBOutlet weak var logoImageView: CustomImageView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!
    
    @IBOutlet weak var favoriteButton: UIButton!

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerFavoriteButtonTap(_ sender: UIButton) {
        isFavorite = !isFavorite
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        handlerFavoriteButtonCompletion!()
    }
}


// MARK: - ConfigureCell
extension OrganizationTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization                    =   item as! Organization
        nameLabel.text                      =   organization.name
        cityLabel.text                      =   organization.addressCity
        streetLabel.text                    =   organization.addressStreet
        ratingView.rating                   =   organization.rating
        isFavorite                          =   organization.isFavorite
        selectionStyle                      =   .none
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-organization"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style              =   (indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
