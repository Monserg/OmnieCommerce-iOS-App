//
//  MSMPickerViewManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMPickerViewManager: UIView {
    // MARK: - Properties
    var days: [[String]]!
    var months: [String]!
    var years: [String]!

    // Selected values
    var selectedMonthIndex: Int = 0
    var selectedDayIndex: Int = 0
    var selectedYearIndex: Int = 0

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.days = Date().getDaysInMonth()
        self.months = Date().getMonthsNumbers()
        self.years = Date().getYears()
        self.selectedMonthIndex = Calendar.current.dateComponents([.month], from: Date()).month! - 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Custom Functions
    func selectedDateDidShow() -> String {
        let monthIndex = (selectedMonthIndex >= 10) ? String(months[selectedMonthIndex]) : "0\(months[selectedMonthIndex])"
        let dayIndex = (selectedDayIndex >= 10) ? String(days[selectedMonthIndex][selectedDayIndex]) : "0\(days[selectedMonthIndex][selectedDayIndex])"
        
        return "\(years[selectedYearIndex])-\(monthIndex)-\(dayIndex)"
    }
}


// MARK: - UIPickerViewDataSource
extension MSMPickerViewManager: UIPickerViewDataSource {
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days[selectedMonthIndex].count
            
        case 2:
            return months.count
            
        case 4:
            return years.count
            
        default:
            return 1
        }
    }
}


// MARK: - UIPickerViewDelegate
extension MSMPickerViewManager: UIPickerViewDelegate {
    // returns width of column and height of row for each component.
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 20.0
            
        case 1:
            return 15
            
        case 2:
            return 20.0
            
        case 4:
            return 35.0
            
        default:
            return 15.0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }
    
    // attributed title is favored if both methods are implemented
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews[0].backgroundColor = UIColor.clear       // background
        pickerView.subviews[1].backgroundColor = UIColor.clear       // top separator line
        pickerView.subviews[2].backgroundColor = UIColor.clear       // bottom separator line

        var label: UILabel!
        
        if view == nil {
            label = UILabel()
        } else {
            label = view as! UILabel
        }
        
        label.font = UIFont(name: "Ubuntu-Light", size: 14.0)
        label.textColor = UIColor.veryLightGray
        label.textAlignment = .center
        
        switch component {
        case 0:
            label.text = days[selectedMonthIndex][row]
            
        case 2:
            label.text = months[row]
            
        case 4:
            label.text = years[row]
            
        default:
            label.text = "."
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedDayIndex = row
            
        case 2:
            selectedMonthIndex = row
            pickerView.reloadComponent(0)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            
        case 4:
            let year = years[row]
            self.days = "01.04.\(year)".convertToDate(withDateFormat: .Default).getDaysInMonth()
            self.months = "01.04.\(year)".convertToDate(withDateFormat: .Default).getMonthsNumbers()
            
            selectedDayIndex = 0
            selectedMonthIndex = 0
            selectedYearIndex = row
            
            pickerView.reloadComponent(0)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)

        default:
            break
        }
    }
}
