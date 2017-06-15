//
//  CurrentTimeLineView.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class CurrentTimeLineView: UIView {
    // MARK: - Properties
    var isShow = false
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {}
    
    
    // MARK: - Custom Functions
    func didMoveToNewPosition(inTableView tableView: UITableView, withCellHeight cellHeight: CGFloat, withScale scale: CGFloat, andAnimation animation: Bool) {
        let currentTimeHour = Date().dateComponents().hour!
        let currentTimeMinute = Date().dateComponents().minute!
        
        guard Int(period.workHourStart) <= currentTimeHour else {
            return
        }
        
        let newPosition = CGPoint.init(x: self.frame.minX,
                                       y: (CGFloat(currentTimeHour - Int(period.workHourStart)) * cellHeight + CGFloat(currentTimeMinute) * cellHeight / 60 - self.frame.height / 2 + 10.0) * scale)
        
        tableView.bringSubview(toFront: self)
        
        UIView.animate(withDuration: (animation) ? 0.5 : 0,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.frame = CGRect.init(origin: newPosition, size: self.frame.size)
        },
                       completion: nil)
    }
}
