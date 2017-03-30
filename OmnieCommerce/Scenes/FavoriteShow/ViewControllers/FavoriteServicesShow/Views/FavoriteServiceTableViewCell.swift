//
//  FavoriteServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoriteServiceTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var isFavorite = false
    var serviceID: String!
    
    var handlerFavoriteButtonTapCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var serviceLabel: UbuntuLightItalicLightGrayishCyanLabel!
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
        
        MSMRestApiManager.instance.userAddRemoveServiceToFavorite(["service": serviceID], withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                    UIImage(named: "image-favorite-star-normal"), for: .normal)
                
                self.handlerFavoriteButtonTapCompletion!(self.serviceID)
            }
        })
    }
}


// MARK: - ConfigureCell
extension FavoriteServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let service = item as! Service
        serviceID = service.codeID
        serviceLabel.text = service.name
        nameLabel.text = service.organizationName
        isFavorite = service.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        //        logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
        //                                  placeholderImage: UIImage.init(named: "image-no-organization"),
        //                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style = .AroundDottedRectangle //(indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
