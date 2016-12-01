//
//  BaseTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

enum CellStyle: String {
    case News       =   "News"
    case Order      =   "Order"
    case Message    =   "Message"
    case Profile    =   "Profile"
    case Service    =   "Service"
    case Handbook   =   "Handbook"
    case Favourite  =   "Favourite"
}

@IBDesignable class BaseTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var borderDottedView: DottedBorderView!
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var describeLabel: CustomLabel!
    
    @IBInspectable var cellStyle: String = ""

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Custom Functions
    func setup(withItem item: Any) {
        backgroundColor = Config.Colors.veryDarkDesaturatedBlue24
        
        switch item {
        case is News:
            let news = item as! News
            nameLabel.text = news.title
            dateLabel.text = news.activeDate.stringFromDate(date: news.activeDate)
            describeLabel.numberOfLines = 2
            describeLabel.text = news.description
            describeLabel.clipsToBounds = false
            
            logoImageView.af_setImage(withURL: URL(string: news.logoStringURL ?? "https://omniesoft.ua/")!, placeholderImage: UIImage.init(named: "image-no-photo"), filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
            
        default:
            break
        }
    }
}
