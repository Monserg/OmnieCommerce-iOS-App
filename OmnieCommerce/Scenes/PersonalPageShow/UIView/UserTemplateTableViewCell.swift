//
//  UserTemplateTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTemplateTableViewCell: UITableViewCell {
    // MARK: - Properties
    let expandedHeight: CGFloat     =   308.0
    let servicesCount               =   4
    
    var isExpanded: Bool            =   false {
        didSet {
            self.dottedBorderViewHeightConstraint.constant  =   (self.isExpanded) ? (self.expandedHeight - 86.0 + CGFloat(self.servicesCount * 17)) : 43.5

            self.handlerSendButtonCompletion!()
        }
    }
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var categoryLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    
    @IBOutlet var serviceLabelsCollection: [UbuntuLightVeryLightGrayLabel]!
    
    @IBOutlet weak var commentTextLabel: UbuntuLightVeryLightGrayLabel! {
        didSet {
            commentTextLabel.lineBreakMode                  =   .byTruncatingTail
            commentTextLabel.numberOfLines                  =   2
            commentTextLabel.adjustsFontSizeToFitWidth      =   false
        }
    }
    
    @IBOutlet weak var dottedBorderViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerExpandButtonTap(_ sender: FillVeryLightOrangeButton) {
        self.dottedBorderView.alpha     =   0
        isExpanded                      =   !isExpanded
        
        sender.setImage(UIImage.init(named: (isExpanded) ? "icon-cell-expand-on-normal" : "icon-cell-expand-off-normal"), for: .normal)
    }
    
    @IBAction func handlerUseTemplateButtonTap(_ sender: FillVeryLightOrangeButton) {
    
    }
    
    @IBAction func handlerDeleteTemplateButtonTap(_ sender: BorderVeryLightOrangeButton) {
    
    }
}


// MARK: - ConfigureCell
extension UserTemplateTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization                =   item as! Organization
        nameLabel.text                  =   organization.name
        categoryLabel.text              =   organization.category.title
        commentTextLabel.text           =   "dasd as das asd asdhasgdh  ashhd gahg ha ajhgd hagd haghs  ajhgdhasgd gags"
        selectionStyle                  =   .none
        
        logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-photo"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style          =   .AroundDottedRectangle
    }
}
