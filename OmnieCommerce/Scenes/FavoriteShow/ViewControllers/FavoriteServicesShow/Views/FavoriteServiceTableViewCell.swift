//
//  FavoriteServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        MSMRestApiManager.instance.userRequestDidRun(.userAddRemoveFavoriteService(["service": serviceID], true), withHandlerResponseAPICompletion: { responseAPI in
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
        isFavorite = service.isFavorite
        selectionStyle = .none

        if (service.isNameNeedHide) {
            nameLabel.isHidden = true
            dottedBorderView.isHidden = true
            favoriteButton.isUserInteractionEnabled = false
        } else {
            nameLabel.isHidden = false
            nameLabel.text = service.organizationName
            dottedBorderView.isHidden = false
            favoriteButton.isUserInteractionEnabled = true
        }
        
        if (service.needBackgroundColorSet && indexPath.row % 2 == 0) {
            backgroundColor = UIColor.init(hexString: "#283643")
        }
        
        favoriteButton.setImage((isFavorite) ?  UIImage(named: "image-favorite-star-selected") :
                                                UIImage(named: "image-favorite-star-normal"), for: .normal)
        
        if let imagePath = service.logoURL {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: "imagePath-\(indexPath.row)"),
                                      placeholder: UIImage.init(named: "image-no-service"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor.init(referenceSize: logoImageView.frame.size, mode: .aspectFit))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-service")
        }
        
        dottedBorderView.style = .AroundDottedRectangle
    }
}
