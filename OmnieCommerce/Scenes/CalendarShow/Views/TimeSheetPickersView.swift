//
//  TimeSheetPickersView.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetPickersView: UIView {
    // MARK: - Properties
    var timesPeriod: TimesPeriod!
    var isShow = false
    
    var fromPickerViewManager: MSMPickerViewManager! {
        didSet {
            guard fromPickerView != nil else {
                return
            }
            
            fromPickerView.delegate = fromPickerViewManager
            fromPickerView.dataSource = fromPickerViewManager
            
            fromPickerViewManager.selectedHourIndex = timesPeriod.hourStart
            fromPickerViewManager.selectedMinuteIndex = timesPeriod.minuteStart
            
            fromPickerView.selectRow(fromPickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
            fromPickerView.selectRow(fromPickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)
            
            // Handler times change
            fromPickerViewManager.handlerChangeHourCompletion = { value in
                self.print(object: "\(value as! Int)")
                self.timesPeriod.hourStart = value as! Int
                
                // Compare times
                self.timesPeriodDidCompare()
            }

            fromPickerViewManager.handlerChangeMinuteCompletion = { value in
                self.print(object: "\(value as! Int)")
                self.timesPeriod.minuteStart = value as! Int
                
                // Compare times
                self.timesPeriodDidCompare()
            }
        }
    }

    var toPickerViewManager: MSMPickerViewManager! {
        didSet {
            guard toPickerView != nil else {
                return
            }
            
            toPickerView.delegate = toPickerViewManager
            toPickerView.dataSource = toPickerViewManager
            
            toPickerViewManager.selectedHourIndex = timesPeriod.hourEnd
            toPickerViewManager.selectedMinuteIndex = timesPeriod.minuteEnd
            
            toPickerView.selectRow(toPickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
            toPickerView.selectRow(toPickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)
            
            // Handler times change
            toPickerViewManager.handlerChangeHourCompletion = { value in
                self.print(object: "\(value as! Int)")
                self.timesPeriod.hourEnd = value as! Int
                
                // Compare times
                self.timesPeriodDidCompare()
            }
            
            toPickerViewManager.handlerChangeMinuteCompletion = { value in
                self.print(object: "\(value as! Int)")
                self.timesPeriod.minuteEnd = value as! Int

                // Compare times
                self.timesPeriodDidCompare()
            }
        }
    }

    var handlerConfirmButtonCompletion: HandlerPassDataCompletion?
    var handlerChangeTimesPeriodCompletion: HandlerPassDataCompletion?

    // Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    
    @IBOutlet weak var fromLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: TimeSheetPickersView.self), bundle: Bundle(for: TimeSheetPickersView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }

    override func draw(_ rect: CGRect) {
        let screenSize = UIScreen.main.bounds
        
        fromLabel.textAlignment = (screenSize.height > screenSize.width) ? .right : .center
    }
    
    // MARK: - Custom Functions
    func pickerViewDidSetup(_ pickerView: UIPickerView, _ pickerViewManager: MSMPickerViewManager) {
        pickerViewManager.selectedHourIndex = (pickerView.tag == 0) ? timesPeriod.hourStart : timesPeriod.hourEnd
        pickerViewManager.selectedMinuteIndex = (pickerView.tag == 0) ? timesPeriod.minuteStart : timesPeriod.minuteEnd
        
        pickerView.selectRow(pickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
        pickerView.selectRow(pickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)
    }
    
    func frameDidChange() {
        let screenSize = UIScreen.main.bounds
        
        if (screenSize.height > screenSize.width) {
            self.frame = CGRect.init(x: 0.0, y: screenSize.height, width: screenSize.width, height: 125.0)
        } else {
            self.frame = CGRect.init(x: screenSize.width, y: 0, width: 185.0, height: screenSize.height)
        }
    }
    
    func didShow(inView view: UIView) {
        let screenSize = UIScreen.main.bounds
        isShow = true
        
        frameDidChange()
        view.addSubview(self)

        if (screenSize.height > screenSize.width) {
            UIView.animate(withDuration: 0.5, animations: { 
                self.frame = CGRect.init(x: 0.0, y: screenSize.height - 125.0, width: screenSize.width, height: 125.0)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect.init(x: screenSize.width - 185.0, y: 0, width: 185.0, height: screenSize.height)
            })
        }
        
        // Create PickerViewManager
        fromPickerViewManager = MSMPickerViewManager.init(self.view.frame, forScene: "TimeSheetPickersView")
        toPickerViewManager = MSMPickerViewManager.init(self.view.frame, forScene: "TimeSheetPickersView")
        
        pickerViewDidSetup(fromPickerView, fromPickerViewManager)
        pickerViewDidSetup(toPickerView, toPickerViewManager)
    }

    override func didHide() {
        let screenSize = UIScreen.main.bounds
        isShow = false

        if (screenSize.height > screenSize.width) {
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect.init(x: 0.0, y: screenSize.height, width: screenSize.width, height: 125.0)
            }, completion: { success in
                self.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect.init(x: screenSize.width, y: 0, width: 185.0, height: screenSize.height)
            }, completion: { success in
                self.removeFromSuperview()
            })
        }
    }

    func timesPeriodDidCompare() {
        if (self.timesPeriod.hourStart > self.timesPeriod.hourEnd) {
            self.toPickerViewManager.selectedHourIndex = self.timesPeriod.hourStart
            self.toPickerViewManager.selectedMinuteIndex = 0
            
            self.toPickerView.selectRow(self.toPickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
            self.toPickerView.selectRow(self.toPickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)

            self.timesPeriod.hourEnd = self.toPickerViewManager.selectedHourIndex
        }
        
        if (self.timesPeriod.hourStart == self.timesPeriod.hourEnd) {
            self.toPickerViewManager.selectedMinuteIndex = self.timesPeriod.minuteStart
            
            self.toPickerView.selectRow(self.toPickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
            self.toPickerView.selectRow(self.toPickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)
        
            self.timesPeriod.minuteEnd = self.toPickerViewManager.selectedMinuteIndex
        }
        
        self.handlerChangeTimesPeriodCompletion!(self.timesPeriod)
    }

    
    // MARK: - Actions
    @IBAction func handlerConfirmButtonTap(_ sender: BorderVeryLightOrangeButton) {
        handlerConfirmButtonCompletion!(timesPeriod)
        self.didHide()
    }
}
