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
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    let expandedHeight: CGFloat     =   310.0
    
    var isExpanded: Bool            =   false {
        didSet {
            self.dottedBorderViewHeightConstraint.constant  =   (self.isExpanded) ? self.expandedHeight : 43.5

            self.dottedBorderView.setNeedsDisplay()
            self.handlerSendButtonCompletion!()

            self.dottedBorderView.alpha     =   1
        }
    }
    
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var categoryLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    
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
    }
}


// MARK: - ConfigureCell
extension UserTemplateTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let organization        =   item as! Organization
        nameLabel.text          =   organization.name
        categoryLabel.text      =   organization.category.title
        selectionStyle          =   .none
        
        logoImageView.af_setImage(withURL: URL(string: organization.logoURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-photo"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style  =   .AroundDottedRectangle
    }
}
