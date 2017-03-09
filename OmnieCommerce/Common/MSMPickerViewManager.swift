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
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.days       =   Date().getDaysInMonth()
        self.months     =   Date().getMonthsNumbers()
        self.years      =   Date().getYears()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            return days.count
            
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
        case 0, 2:
            return self.widthRatio * 25.0
            
        case 4:
            return self.widthRatio * 45.0
            
        default:
            return self.widthRatio * 10.0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.heightRatio * 45.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nil
    }
    
    // attributed title is favored if both methods are implemented
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        if view == nil {
            label   =   UILabel()
        } else {
            label   =   view as! UILabel
        }
        
        label.font          =   UIFont(name: "Ubuntu-Light", size: 14.0)
        label.textColor     =   UIColor.veryLightGray
        label.textAlignment =   .center
        
        switch component {
        case 0:
            label.text      =   "fff" //days[months[row]]
            
        case 2:
            label.text      =   months[row]
            
        case 4:
            label.text      =   years[row]
            
        default:
            label.text      =   "."
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 2:
            pickerView.reloadComponent(0)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            
        case 4:
            let year        =   self.years[row]
            self.days       =   "01.04.\(year)".convertToDate().getDaysInMonth()
            self.months     =   "01.04.\(year)".convertToDate().getMonthsNumbers()
            
            pickerView.reloadComponent(0)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)

        default:
            break
        }
    }
}
