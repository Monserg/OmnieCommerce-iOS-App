//
//  TimerPointer.swift
//  UITableViewCellPinchDemo
//
//  Created by msm72 on 15.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class TimePointer: UIView {
    // MARK: - Class Functions
    func didMoveToNewPosition(forOrganization organization: Organization, inTableView tableView: UITableView, withCellHeight cellHeight: CGFloat, andAnimation animation: Bool) {
        let workedOutHours = Date().dateComponents().hour! - organization.workStartTime
        let workedOutMinutes = Date().dateComponents().minute!
        let newPosition = CGPoint.init(x: self.frame.minX, y: 8.5 - frame.height / 2 + CGFloat(workedOutHours) * cellHeight + CGFloat(workedOutMinutes) * cellHeight / 60)

        UIView.animate(withDuration: (animation) ? 0.5 : 0, delay: 0, options: .curveLinear, animations: {
            self.frame = CGRect.init(origin: newPosition, size: self.frame.size)
        }, completion: nil)
    }
}
