//
//  ExpandedHeaderCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class ExpandedHeaderCell: NSObject, InitCellParameters {
    // MARK: - Properties
    var name: String!
    var isExpanded: Bool = false
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ExpandedTableViewHeaderView"
    var cellHeight: CGFloat = 37.0
    
    
    // MARK: - Class Initialization
    init(withName name: String) {
        super.init()
        
        self.name = name
    }
}
