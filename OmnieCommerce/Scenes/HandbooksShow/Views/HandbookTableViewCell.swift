//
//  HandbookTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher

class HandbookTableViewCell: UITableViewCell, DottedBorderViewBinding, iCarouselDataSource, iCarouselDelegate {
    // MARK: - Properties
    var phones: [String]?
    var tags: [String]?
    var handbookID: String!
    
    var handlerPhoneButtonTapCompletion: HandlerPassDataCompletion?
    var handlerBussinessCardButtonTapCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Outlets
    @IBOutlet weak var organizationNameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var addressLabel: UbuntuLightItalicLightGrayishCyanLabel!
    @IBOutlet weak var phoneButton: FillVeryLightOrangeButton!
    @IBOutlet weak var cardButton: FillVeryLightOrangeButton!
    @IBOutlet weak var organizationImageView: CustomImageView!
    @IBOutlet weak var carouselView: iCarousel!
    
    @IBOutlet weak var dottedBorderView: DottedBorderView! {
        didSet {
            dottedBorderView.style = .AroundDottedRectangle
        }
    }

    
    // MARK: - Class Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPhoneButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerPhoneButtonTapCompletion!(phones)
    }
    
    @IBAction func handlerCardButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerBussinessCardButtonTapCompletion!(self.handbookID)
    }
    

    // MARK: - iCarouselDataSource
    func numberOfItems(in carousel: iCarousel) -> Int {
        return (self.tags == nil) ? 0 : self.tags!.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tagButton = BorderVeryDarkDesaturatedBlueButton(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: carousel.itemWidth, height: 15.0)))
        tagButton.setTitle(self.tags![index], for: .normal)
        
        return tagButton
    }

    
    // MARK: - iCarouselDelegate
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.2
        }
        
        return value
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        guard self.tags != nil else {
            return 0
        }
        
        var maxLenght: CGFloat!
        
        if self.tags!.count > 1 {
            let maxString = self.tags!.max{ $0.characters.count < $1.characters.count }!
            maxLenght = CGFloat(Double(maxString.characters.count) * 9.5)
        } else {
            maxLenght = CGFloat(Double(self.tags!.first!.characters.count) * 9.5)
        }
        
        carouselView.viewpointOffset = CGSize(width: (carousel.frame.width - maxLenght) / 2.0, height: 0.0)
        
        return maxLenght
    }
}


// MARK: - ConfigureCell
extension HandbookTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let handbook = item as! Handbook

        self.handbookID = handbook.codeID
        self.organizationNameLabel.text = handbook.name
        selectionStyle = .none
        carouselView.type = .linear
        carouselView.isPagingEnabled = false
        carouselView.centerItemWhenSelected = true
        carouselView.bounces = true

        if let phonesList = handbook.phones, phonesList.count > 0 {
            self.phones = phonesList
        } else {
            self.phoneButton.isHidden = true
        }
        
        if let tagsList = handbook.tags, tagsList.count > 0 {
            self.tags = tagsList
            self.carouselView.reloadData()
        } else {
            self.carouselView.isHidden = true
        }
        
        if let addressString = handbook.address {
            self.addressLabel.text = addressString
        } else {
            self.addressLabel.isHidden = true
        }
        
        if let imageID = handbook.imageID {
            organizationImageView.kf.setImage(with: ImageResource(downloadURL: imageID.convertToURL(withSize: .Small, inMode: .Get), cacheKey: imageID),
                                              placeholder: nil,
                                              options: [.transition(ImageTransition.fade(1)),
                                                        .processor(ResizingImageProcessor(referenceSize: organizationImageView.frame.size,
                                                                                          mode: .aspectFill))],
                                              completionHandler: { image, error, cacheType, imageURL in
                                                self.organizationImageView.kf.cancelDownloadTask()
            })
        } else {
            organizationImageView.contentMode = .center
            
            UIView.animate(withDuration: 0.5, animations: {
                self.organizationImageView.backgroundColor = UIColor.veryDarkGrayishBlue38
                self.organizationImageView.image = UIImage.init(named: "image-no-organization")
            })
        }
    }
}
