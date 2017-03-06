//
//  NewsTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    @IBOutlet weak var describeLabel: UbuntuLightItalicLightGrayishCyanLabel!

    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: - ConfigureCell
extension NewsTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let news                            =   item as! News
        nameLabel.text                      =   news.name
        dateLabel.text                      =   news.activeDate.convertToString(withStyle: .Date)
        describeLabel.numberOfLines         =   2
        describeLabel.text                  =   news.description
        describeLabel.clipsToBounds         =   false
        selectionStyle                      =   .none
        
        logoImageView.af_setImage(withURL: URL(string: news.logoStringURL ?? "https://omniesoft.ua/")!,
                                  placeholderImage: UIImage.init(named: "image-no-photo"),
                                  filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: logoImageView.frame.size, radius: logoImageView.frame.size.width / 2))
        
        dottedBorderView.style              =   .AroundDottedRectangle
    }
}
