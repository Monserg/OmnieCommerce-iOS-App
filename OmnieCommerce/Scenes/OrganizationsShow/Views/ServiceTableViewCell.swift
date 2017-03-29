//
//  ServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import AlamofireImage

class ServiceTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var isFavorite = false
    var serviceID: String!
    
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
        
        MSMRestApiManager.instance.userAddRemoveServiceToFavorite(["service" : serviceID], withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                    UIImage(named: "image-favorite-star-normal"), for: .normal)
            }
        })
    }
}


// MARK: - ConfigureCell
extension ServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let service = item as! Service
        serviceID = service.codeID
        nameLabel.text = service.name
        cityLabel.text = service.addressCity!
        streetLabel.text = service.addressStreet!
        ratingView.rating = service.rating!
        isFavorite = service.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ? UIImage(named: "image-favorite-star-selected") : UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        logoImageView.af_setImage(withURL: URL(string: service.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-organization"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style = (indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
