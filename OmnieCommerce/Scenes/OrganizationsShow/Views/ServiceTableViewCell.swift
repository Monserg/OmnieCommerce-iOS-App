//
//  ServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ServiceTableViewCell: UITableViewCell, DottedBorderViewBinding {
    // MARK: - Properties
    var isFavorite = false
    var serviceID: String!
    
    // Outlets
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
        
        MSMRestApiManager.instance.userRequestDidRun(.userAddRemoveFavoriteService(["service": serviceID], true), withHandlerResponseAPICompletion: { responseAPI in
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
        nameLabel.text = service.name ?? "XXX"
        cityLabel.text = service.addressCity ?? "XXX"
        streetLabel.text = service.addressStreet ?? "XXX"
        ratingView.rating = service.rating
        isFavorite = service.isFavorite
        selectionStyle = .none
        
        favoriteButton.setImage((isFavorite) ?  UIImage(named: "image-favorite-star-selected") :
                                                UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        if let imageID = service.imageID {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: serviceID),
                                      placeholder: UIImage.init(named: "image-no-service"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor(referenceSize: logoImageView.frame.size,
                                                                                  mode: .aspectFill))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-service")
        }
        
        dottedBorderView.style = (indexPath.row <= 1) ? .AroundDottedRectangleColor : .AroundDottedRectangle
    }
}
