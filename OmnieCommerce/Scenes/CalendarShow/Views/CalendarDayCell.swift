//
//  CalendarDayCell.swift
//  JTAppleCalendarDemo
//
//  Created by msm72 on 03.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDayCell: JTAppleCell {
    // MARK: - Properties
    @IBOutlet weak var dateLabel: UbuntuLightVeryLightGrayLabel!
    
    @IBOutlet weak var selectedView: CustomView! {
        didSet {
            selectedView.style = "Fill"
        }
    }

    
    @IBOutlet weak var currentView: CustomView! {
        didSet {
            currentView.style = "Border"
        }
    }

    
    // MARK: - Custom Functions
    func viewDidUpload(forCellState cellState: CellState) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        selectedView.layer.cornerRadius = (frame.height > frame.width) ? (frame.width - 2 ) / 2 : (frame.height - 2) / 2
        selectedView.isHidden = !cellState.isSelected
        
        currentView.layer.cornerRadius = (frame.height > frame.width) ? (frame.width - 2) / 2 : (frame.height - 2) / 2
        currentView.isHidden = (dateFormatter.string(from: Date()) == dateFormatter.string(from: cellState.date)) ? false : true

        // Text colors
        switch cellState.isSelected {
        case true:
            dateLabel.textColor = (isLightColorAppSchema) ? UIColor.black : UIColor.veryLightGray
            
        default:
            if (cellState.dateBelongsTo == .thisMonth) {
                dateLabel.textColor = (isLightColorAppSchema) ? UIColor.red : UIColor.veryLightGray
            } else {
                dateLabel.textColor = (isLightColorAppSchema) ? UIColor.blue : UIColor.veryDarkGrayishBlue56
            }
        }
        
        setNeedsDisplay()
    }
}
