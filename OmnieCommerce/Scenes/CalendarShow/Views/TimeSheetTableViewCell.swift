//
//  TimeSheetTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
    // MAK: - Outlets
    @IBOutlet weak var timeLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var zeroMinuteView: UIView!
    
    @IBOutlet weak var zeroMinuteLineView: DottedBorderView! {
        didSet {
            zeroMinuteLineView.style = .MiddleDottedLine
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
        selectionStyle = .none
        
        if (indexPath.row == 1) {
            zeroMinuteView.setNeedsLayout()
            period.timeOffset = Float(zeroMinuteView.frame.midY)
        }
    }
}
