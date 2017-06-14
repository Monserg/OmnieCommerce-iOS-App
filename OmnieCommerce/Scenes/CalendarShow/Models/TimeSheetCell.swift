//
//  TimeSheetCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class TimeSheetCell: NSObject, InitCellParameters {
    // MARK: - Properties
    var start: String!
    var end: String!
    
    
    // MARK: - Class Initialization
    init(start: String, end: String, height: CGFloat) {
        super.init()
        
        self.start = start
        self.end = end
        self.cellIdentifier = "TimeSheetTableViewCell"
        self.cellHeight = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Confirm to InitCellParameters protocol
    var cellIdentifier = "TimeSheetTableViewCell"
    var cellHeight: CGFloat = 44.0
}
