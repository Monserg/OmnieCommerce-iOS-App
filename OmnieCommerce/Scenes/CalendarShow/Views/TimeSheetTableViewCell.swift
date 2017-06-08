//
//  TimeSheetTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentTimeLineView: UIView!
    
    @IBOutlet weak var topDottedLineView: DottedBorderView! {
        didSet {
            topDottedLineView.style = .BottomDottedLine
        }
    }
    
    @IBOutlet weak var bottomDottedLineView: DottedBorderView! {
        didSet {
            bottomDottedLineView.style = .BottomDottedLine
        }
    }
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: - ConfigureCell
extension TimeSheetTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let timeSheetCell = item as! TimeSheetCell
        
        timeLabel.text = timeSheetCell.start
            //.components(separatedBy: "T").last!
        selectionStyle = .none
    }
}
