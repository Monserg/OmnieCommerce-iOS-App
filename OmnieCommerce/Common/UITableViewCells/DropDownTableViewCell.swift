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
        self.contentView.backgroundColor    =   UIColor.veryDarkDesaturatedBlue24
        self.nameLabel.backgroundColor      =   UIColor.veryDarkDesaturatedBlue24
    }
    
    
    // MARK: - Custom Functions
    func didSetup(withCity city: City) {
        self.nameLabel.text             =   city.name
        
        // Set selected color
        let selectedView                =   UIView.init(frame: self.frame)
        selectedView.backgroundColor    =   UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        
        self.selectedBackgroundView     =   selectedView
    }
}
