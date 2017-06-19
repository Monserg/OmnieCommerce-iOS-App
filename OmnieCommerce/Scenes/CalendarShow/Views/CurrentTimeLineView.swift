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
    
    
    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UbuntuLightVeryLightGrayLabel!
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {}
    
    
    // MARK: - Custom Functions
    func didMoveToNewPosition(inTableView tableView: UITableView, andAnimation animation: Bool) {
        let currentTimeHour = Date().dateComponents().hour!
        let currentTimeMinute = Date().dateComponents().minute!
        
        guard Int(period.workHourStart) <= currentTimeHour else {
            return
        }
        
        // minY = (timeOffset + hour * cellHeight + minute * cellHeight / 60 - halfHeight ) * scale
        let newPosition = CGPoint.init(x: self.frame.minX,
                                       y: (CGFloat(period.timeOffset) * CGFloat(period.scale) + CGFloat(currentTimeHour - Int(period.workHourStart)) * CGFloat(period.cellHeight) * CGFloat(period.scale) + CGFloat(currentTimeMinute) * CGFloat(period.cellHeight) / 60 * CGFloat(period.scale) - self.frame.height / 2 * CGFloat(period.scale)))
        
        tableView.bringSubview(toFront: self)
        
        UIView.animate(withDuration: (animation) ? 0.5 : 0,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.frame = CGRect.init(origin: newPosition, size: self.frame.size)
        },
                       completion: { success in
                        self.timeLabel.isHidden = true
        })
    }
    
    
    // MARK: - Gestures
    @IBAction func handlerTapGesture(_ sender: UITapGestureRecognizer) {
        timeLabel.text = self.convertToCurrentTime()
        timeLabel.isHidden = false
    }
}
