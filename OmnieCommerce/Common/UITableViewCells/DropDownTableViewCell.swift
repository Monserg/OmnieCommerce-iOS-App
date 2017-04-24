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
    var itemCode: String!
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    
    
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
    }
}


extension DropDownTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let dropDownValue = item as! DropDownItem
        
        itemCode = dropDownValue.codeID
        nameLabel.text = dropDownValue.name
        selectionStyle = .none
        
        // Set selected color
        let selectedView = UIView.init(frame: self.frame)
        selectedView.backgroundColor = UIColor.init(hexString: "#38444e", withAlpha: 0.3)
        
        self.selectedBackgroundView = selectedView
    }
}
