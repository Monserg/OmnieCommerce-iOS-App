//
//  CalendarDayCellView.swift
//  CustomCalendarDemo
//
//  Created by msm72 on 10.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDayCellView: JTAppleDayCellView {
    // MARK: - Properties
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var selectedView: CustomView!
    @IBOutlet weak var currentDayView: CustomView!
    
    // MARK: - Class Functions
    func setupBeforeDisplay(forDate date: Date, witState state: CellState) {
        dayLabel.text = state.text
        
        setTextColor(forState: state)
        setSelection(forState: state)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        currentDayView.isHidden = (dateFormatter.string(from: Date()) == dateFormatter.string(from: date)) ? false : true
        backgroundColor = (Config.Constants.isAppThemesDark) ? UIColor.green : UIColor.veryDarkDesaturatedBlue24
        
        if (!currentDayView.isHidden) {
            layoutIfNeeded()
            currentDayView.layer.cornerRadius = currentDayView.bounds.height / 2
        }
    }
    
    func setTextColor(forState state: CellState) {
        switch state.isSelected {
        case true:
            dayLabel.textColor = (Config.Constants.isAppThemesDark) ? UIColor.black : UIColor.veryLightGray

        default:
            if (state.dateBelongsTo == .thisMonth) {
                dayLabel.textColor = (Config.Constants.isAppThemesDark) ? UIColor.red : UIColor.veryLightGray
            } else {
                dayLabel.textColor = (Config.Constants.isAppThemesDark) ? UIColor.blue : UIColor.veryDarkGrayishBlue56
            }
        }
    }
    
    func setSelection(forState state: CellState) {        
        switch state.isSelected {
        case true:
            layoutIfNeeded()
            selectedView.layer.cornerRadius = selectedView.bounds.height / 2
            selectedView.isHidden = false

        default:
            selectedView.isHidden = true
        }
    }    
}
