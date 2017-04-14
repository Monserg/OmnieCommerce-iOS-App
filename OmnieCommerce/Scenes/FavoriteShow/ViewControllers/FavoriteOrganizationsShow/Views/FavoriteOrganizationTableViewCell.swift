//
//  FavoriteOrganizationTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

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
        isFavorite = organization.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ?  UIImage(named: "image-favorite-star-selected") :
                                                UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        if let imagePath = organization.logoURL {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: organizationID),
                                      placeholder: UIImage.init(named: "image-no-organization"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor(referenceSize: logoImageView.frame.size,
                                                                                  mode: .aspectFit))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-organization")
        }
        
        dottedBorderView.style = .AroundDottedRectangle
    }
}
