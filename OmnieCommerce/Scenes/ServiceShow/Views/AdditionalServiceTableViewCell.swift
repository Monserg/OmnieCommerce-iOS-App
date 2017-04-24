//
//  AdditionalServiceTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class AdditionalServiceTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet var labelsCollection: [UILabel]!
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var priceLabel: UbuntuLightVeryLightOrangeLabel!
    @IBOutlet weak var durationLabel: UbuntuLightItalicLightGrayishCyanLabel!
    
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!

    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerChangeSwitchState(_ sender: UISwitch) {
        let _ = labelsCollection.map { $0.isEnabled = sender.isOn }
    }
}


// MARK: - ConfigureCell
extension AdditionalServiceTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let discount = item as! Discount
        
//        nameLabel.numberOfLines = 0
//        nameLabel.text = "\(discount.name), \(discount.percent)%"
//        nameLabel.sizeToFit()
//        dateLabel.text = "\("Discount period".localized()) \((discount.dateStart as Date).convertToString(withStyle: .Date)) - \((discount.dateEnd as Date).convertToString(withStyle: .Date))"
        
        //        // Set selected color
        //        let selectedView = UIView.init(frame: self.frame)
        //        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        //        self.selectedBackgroundView = selectedView
    }
}
