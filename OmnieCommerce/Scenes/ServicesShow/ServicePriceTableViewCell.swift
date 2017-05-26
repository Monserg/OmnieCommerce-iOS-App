//
//  ServicePriceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ServicePriceTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightOrangeLabel!
    @IBOutlet weak var lineView: UIView!
    

    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


// MARK: - ConfigureCell
extension ServicePriceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let price = item as! Price
        
        nameLabel.numberOfLines = 1
        nameLabel.text = price.service?.name
        nameLabel.sizeToFit()
        
        priceLabel.text = "\(price.price) \(price.unit.convertToUnitString() ?? "???")"
        
        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.9)
        self.selectedBackgroundView = selectedView
    }
}
