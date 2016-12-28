//
//  SchedulerViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum TransitionDirection {
    case Next
    case Previuos
}

class SchedulerViewController: UIViewController {
    // MARK: - Properties
    var selectedDate = Date()
    
    var pageIndex: Int = 367 {
        willSet {
            if (pageIndex < newValue) {
                // Next
                changeSelectedDate(to: .Next)
            } else if (pageIndex > newValue) {
                // Previous
                changeSelectedDate(to: .Previuos)
            } else {
                setupTitleLabel(withDate: selectedDate)
            }
        }
    }

    @IBOutlet weak var timeTitleLabel: CustomLabel!
    @IBOutlet weak var schedulerView: UIView!
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSchedulerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Custom Functions
    func setupSchedulerView() {
        setupTitleLabel(withDate: selectedDate)
    }
    
    func setupTitleLabel(withDate date: Date) {
        guard timeTitleLabel != nil else {
            return
        }
        
        timeTitleLabel.text = date.convertToString(withStyle: .WeekdayMonthYear)
    }
    
    func changeSelectedDate(to direction: TransitionDirection) {
        selectedDate = (direction == .Previuos) ? selectedDate.previousDate() : selectedDate.nextDate()
        setupTitleLabel(withDate: selectedDate)
    }
    
    func redraw() {
    }
}
