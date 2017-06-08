//
//  TimeSheetCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

struct TimeSheetCell: InitCellParameters {
    let start: String
    let end: String
    
    // Confirm to InitCellParameters protocol
    var cellIdentifier = "TimeSheetTableViewCell"
    var cellHeight: CGFloat = 44.0
}
