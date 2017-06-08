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
    var scene: String!
    
    var days: [[String]]!
    var months: [String]!
    var years: [String]!
    var hours: [String]!
    var minutes: [String]!

    // Selected values
    var selectedMonthIndex: Int = 0 {
        willSet {
            if (scene == "SettingsShow") {
                self.days[newValue].insert("0", at: 0)
            }
        }
    }
    var selectedDayIndex: Int = 0
    var selectedYearIndex: Int = 0
    var selectedHourIndex: Int = 0
    var selectedMinuteIndex: Int = 0

    // Handler only for Order
    var handlerChangeHourCompletion: HandlerPassDataCompletion?
    var handlerChangeMinuteCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(_ frame: CGRect, forScene scene: String) {
        super.init(frame: frame)
        
        switch scene {
        case "SettingsShow":
            self.days = Date().getDaysInMonth()
            self.months = Date().getMonthsNumbers()
            self.hours = Date().getHours()
            self.minutes = Date().getMinutes()

        case "PersonalPageShow":
            self.days = Date().getDaysInMonth()
            self.months = Date().getMonthsNumbers()
            self.years = Date().getYears()

        case "TimeSheetPickersView":
            self.hours = Date().getHours()
            self.minutes = Date().getMinutes()

        default:
            break
        }

        self.selectedMonthIndex = Calendar.current.dateComponents([.month], from: Date()).month! - 1
        self.scene = scene
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
        return (scene == "TimeSheetPickersView") ? 3 : 5
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return (scene == "TimeSheetPickersView") ? hours.count : days[selectedMonthIndex].count
            
        case 2:
            return (scene == "PersonalPageShow") ? months.count : (scene == "TimeSheetPickersView") ? minutes.count : hours.count
            
        case 4:
            return (scene == "PersonalPageShow") ? years.count : minutes.count
            
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
            return (scene == "PersonalPageShow") ? 20.0 : 23.0
            
        case 1:
            return (scene == "PersonalPageShow") ? 15.0 : (scene == "TimeSheetPickersView") ? 5.0 : 22.0
            
        case 2:
            return (scene == "TimeSheetPickersView") ? 23.0 : 20.0
            
        case 4:
            return (scene == "PersonalPageShow") ? 35.0 : 20.0
            
        default:
            return (scene == "PersonalPageShow") ? 15.0 : 30.0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (scene == "PersonalPageShow") ? 35.0 : 33.0
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
        
        label.font = (scene == "TimeSheetPickersView") ? UIFont(name: "Ubuntu-Light", size: 19.0) : UIFont(name: "Ubuntu-Light", size: 14.0)
        label.textColor = UIColor.veryLightGray
        label.textAlignment = .center
        
        switch component {
        case 0:
            if (scene == "TimeSheetPickersView") {
                label.text = hours[row].twoNumberFormat()
            } else {
                label.text = days[selectedMonthIndex][row]
            }
            
        case 2:
            if (scene == "TimeSheetPickersView") {
                label.text = minutes[row].twoNumberFormat()
            } else {
                label.text = (scene == "PersonalPageShow") ? months[row] : hours[row]
            }
            
        case 4:
            label.text = (scene == "PersonalPageShow") ? years[row] : minutes[row]
            
        default:
            label.text = (scene == "PersonalPageShow") ? "." : (scene == "TimeSheetPickersView") ? ":" : nil
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if (scene == "TimeSheetPickersView") {
                selectedHourIndex = row
                handlerChangeHourCompletion!(row)
            } else {
                selectedDayIndex = row
            }
            
        case 2:
            if (scene == "PersonalPageShow") {
                selectedMonthIndex = row
                pickerView.reloadComponent(0)
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            
            if (scene == "SettingsShow") {
                selectedHourIndex = row
            }
            
            if (scene == "TimeSheetPickersView") {
                selectedMinuteIndex = row
                handlerChangeMinuteCompletion!(row)
            }
            
        case 4:
            // PersonalPageShow
            if (scene == "PersonalPageShow") {
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
            }
            
            // SettingsShow
            if (scene == "SettingsShow") {
                selectedMinuteIndex = row
            }

        default:
            break
        }
    }
}
