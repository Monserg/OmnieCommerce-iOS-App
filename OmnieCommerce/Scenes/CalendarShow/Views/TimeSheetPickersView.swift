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
            
            fromPickerView.selectRow(toPickerViewManager.selectedHourIndex, inComponent: 0, animated: true)
            fromPickerView.selectRow(toPickerViewManager.selectedMinuteIndex, inComponent: 2, animated: true)
        }
    }

    var handlerConfirmButtonCompletion: HandlerPassDataCompletion?
    
    // Outlets
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
        
        
        // Create PickerViewManager
        fromPickerViewManager = MSMPickerViewManager.init(self.view.frame, forScene: "TimeSheetPickersView")
        toPickerViewManager = MSMPickerViewManager.init(self.view.frame, forScene: "TimeSheetPickersView")
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

    
    // MARK: - Custom Functions
    func frameDidChange() {
        let screenSize = UIScreen.main.bounds
        
        if (UIDevice.current.orientation.isPortrait) {
            self.frame = CGRect.init(x: 0.0, y: screenSize.height, width: screenSize.width, height: 125.0)
        } else {
            self.frame = CGRect.init(x: screenSize.width, y: 0, width: 185.0, height: screenSize.height)
        }
    }
    
    override func didShow() {
        if (UIDevice.current.orientation.isPortrait) {
            UIView.animate(withDuration: 0.5, animations: { 
                self.view.transform = CGAffineTransform(translationX: 0, y: -125.0)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: -185.0, y: 0)
            })
        }
    }

    override func didHide() {
        if (UIDevice.current.orientation.isPortrait) {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: 125.0)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: 185.0, y: 0)
            })
        }
    }

    
    // MARK: - Actions
    @IBAction func handlerConfirmButtonTap(_ sender: BorderVeryLightOrangeButton) {
        handlerConfirmButtonCompletion!("ADD DATA!!!")
    }
}
