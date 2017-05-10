//
//  DiscountTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var dateLabel: UbuntuLightItalicLightGrayishCyanLabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: - ConfigureCell
extension DiscountTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let discount = item as! Discount
        nameLabel.numberOfLines = 0
        nameLabel.text = "\(discount.name), \(discount.percent)%"
        nameLabel.sizeToFit()
        dateLabel.text = "\("Discount period".localized()) \((discount.dateStart as Date).convertToString(withStyle: .DateDot)) - \((discount.dateEnd as Date).convertToString(withStyle: .DateDot))"
        
//        // Set selected color
//        let selectedView = UIView.init(frame: self.frame)
//        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
//        self.selectedBackgroundView = selectedView
    }
}
