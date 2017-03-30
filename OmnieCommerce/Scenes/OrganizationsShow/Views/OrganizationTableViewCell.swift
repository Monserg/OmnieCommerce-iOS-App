//
//  OrganizationTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import Toucan
import Kingfisher

class OrganizationTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var isFavorite = false
    var organizationID: String!
    
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
        
        MSMRestApiManager.instance.userAddRemoveOrganizationToFavorite(["organization" : organizationID], withHandlerResponseAPICompletion: { responseAPI in
            if (responseAPI?.code == 200) {
                self.favoriteButton.setImage((self.isFavorite) ?    UIImage(named: "image-favorite-star-selected") :
                                                                    UIImage(named: "image-favorite-star-normal"), for: .normal)
            }
        })
    }
}


// MARK: - ConfigureCell
extension OrganizationTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization = item as! Organization
        organizationID = organization.codeID
        nameLabel.text = organization.name
        cityLabel.text = organization.addressCity!
        streetLabel.text = organization.addressStreet!
        ratingView.rating = organization.rating!
        isFavorite = organization.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ?  UIImage(named: "image-favorite-star-selected") :
                                                UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        if let imagePath = organization.logoURL {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: organizationID),
                                      placeholder: UIImage.init(named: "image-no-organization"),
                                      options: [.transition(ImageTransition.fade(1))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        if (image != nil) {
                                            self.logoImageView.image = Toucan(image: image!)
                                                .resize(self.logoImageView.frame.size, fitMode: Toucan.Resize.FitMode.crop)
                                                .maskWithEllipse().image
                                        }
                                        
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        }
        
        dottedBorderView.style = (indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
