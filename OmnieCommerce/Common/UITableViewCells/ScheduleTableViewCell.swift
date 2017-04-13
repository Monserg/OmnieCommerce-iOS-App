//
//  ScheduleTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UbuntuLightSoftOrangeLabel!
    @IBOutlet weak var workTimeLabel: UbuntuLightVeryLightGrayLabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
