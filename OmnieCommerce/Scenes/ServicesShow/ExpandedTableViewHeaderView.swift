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
    var handlerExpandButtonTapCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var nameLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var expandButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func handlerExpandButtonTap(_ sender: UIButton) {
        sender.tag = (sender.tag == 0) ? 1 : 0
        expandButton.setImage(UIImage.init(named: (sender.tag == 0) ? "icon-top-item-normal" : "icon-bottom-item-normal"), for: .normal)
        
        handlerExpandButtonTapCompletion!(sender)
    }
}
