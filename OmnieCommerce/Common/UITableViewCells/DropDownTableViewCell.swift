//
//  DropDownTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class DropDownTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: CustomLabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        self.contentView.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        self.nameLabel.backgroundColor = UIColor.veryDarkDesaturatedBlue24
    }
}
