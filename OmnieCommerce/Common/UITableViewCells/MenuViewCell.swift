//
//  MenuViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    
    // MARK: - Custom Functions
    func setup(menuItem: NSDictionary) {
        titleLabel.text = (menuItem.object(forKey: "name") as! String).localized()
    }
}
