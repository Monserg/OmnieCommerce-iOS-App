//
//  MessageTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

@IBDesignable class MessageTableViewCell: UITableViewCell {
    // MARK: - Properties    
    @IBOutlet weak var nameLabel: UbuntuLight12VeryLightGrayLabel!
    @IBOutlet weak var messageLabel: UbuntuLightItalic09LightGrayishCyanLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalic09VeryDarkGrayishBlueLabel!
    
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var userAvatarImageView: CustomImageView!
    
    @IBOutlet weak var dottedBorderView: DottedBorderView!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


// MARK: - ConfigureCell
extension MessageTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let message         =   item as! Message
        nameLabel.text      =   message.name
        messageLabel.text   =   message.text
        dateLabel.text      =   message.activeDate.convertToString(withStyle: (message.activeDate.isActiveToday()) ? .Time : .Date)
        selectionStyle      =   .none

        logoImageView.af_setImage(withURL: URL(string: message.logoStringURL ?? "https://blog.testfort.com/wp-content/uploads/2015/07/apple_logo.png")!,
                                  placeholderImage: UIImage.init(named: "image-no-photo"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style  =   .AroundDottedRectangle
        
        if (message.isOwn) {
            userAvatarImageView.isHidden    =  false
            userAvatarImageView.frame       =   CGRect.init(origin: .zero, size: CGSize.init(width: 20, height: 20))
            
            userAvatarImageView.af_setImage(withURL: URL(string: message.userAvatarStringURL ?? "http://static1.milkcapmania.co.uk/Img/Other/TV%20Story%20Vedettos/300DPI/Sylvester-Stallone.png")!,
                                            placeholderImage: UIImage.init(named: "image-no-user"),
                                            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: userAvatarImageView.frame.size, radius: userAvatarImageView.frame.height / 2))
        } else {
            userAvatarImageView.isHidden    =  true
        }
    }
}
