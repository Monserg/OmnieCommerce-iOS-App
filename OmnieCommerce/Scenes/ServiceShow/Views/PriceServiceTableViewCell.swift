//
//  PriceServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PriceServiceTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var dayNameLabel: UbuntuLightSoftOrangeLabel!
    @IBOutlet weak var periodLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightGrayLabel!
    

    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}


// MARK: - ConfigureCell
extension PriceServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let price = item as! Price
        
        dayNameLabel.text = price.dayName
        periodLabel.text = "\("From".localized()) \(price.ruleTimeStart) \("To".localized()) \(price.ruleTimeEnd)"
        priceLabel.text = "\(price.price) \(price.unitName)"
    }
}
