//
//  ExpandedTableViewHeaderView.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ExpandedTableViewHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties
    var isExpanded = false
    var handlerExpandButtonTapCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var additionalExpandButton: UIButton!
    
    
    // MARK: - Custom Functions
    func showAllItems() {
        isExpanded = true
        expandButton.isHidden = true
        additionalExpandButton.isHidden = true
    }
    
    
    // MARK: - Actions
    @IBAction func handlerExpandButtonTap(_ sender: UIButton) {
        isExpanded = !isExpanded
        self.handlerExpandButtonTapCompletion!(self.isExpanded)
    }
}


// MARK: - ConfigureCell
extension ExpandedTableViewHeaderView: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let cell = item as! ExpandedHeaderCell
        
        nameLabel.numberOfLines = 1
        nameLabel.text = cell.name
        nameLabel.sizeToFit()
        isExpanded = cell.isExpanded

        if (cell.mode == .PriceList) {
            showAllItems()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.expandButton.transform = (self.isExpanded) ? CGAffineTransform.init(rotationAngle: .pi) : CGAffineTransform.identity
        })
    }
}
