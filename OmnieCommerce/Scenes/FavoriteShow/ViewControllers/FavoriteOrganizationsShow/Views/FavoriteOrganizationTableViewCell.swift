//
//  FavoriteOrganizationTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoriteOrganizationTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var isFavorite = false
    var organizationID: String!
    
    var handlerFavoriteButtonTapCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    
    @IBOutlet weak var logoImageView: CustomImageView!
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
        
        MSMRestApiManager.instance.userAddRemoveOrganizationToFavorite(["organization" : organizationID], withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                    UIImage(named: "image-favorite-star-normal"), for: .normal)
                
                self.handlerFavoriteButtonTapCompletion!(self.organizationID)
            }
        })
    }
}


// MARK: - ConfigureCell
extension FavoriteOrganizationTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization = item as! Organization
        organizationID = organization.codeID
        nameLabel.text = organization.name
//        subcategoryLabel.text = organization.category.name
        isFavorite = organization.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-organization"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style = .AroundDottedRectangle //(indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
