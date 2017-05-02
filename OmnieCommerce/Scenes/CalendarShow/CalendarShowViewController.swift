//
//  CalendarShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.12.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Device
import JTAppleCalendar

// MARK: - Input & Output protocols
protocol CalendarShowViewControllerInput {
    func displaySomething(viewModel: CalendarShow.Something.ViewModel)
}

protocol CalendarShowViewControllerOutput {
    func doSomething(request: CalendarShow.Something.Request)
}

class CalendarShowViewController: BaseViewController, CalendarShowViewControllerInput {
    // MARK: - Properties
    var output: CalendarShowViewControllerOutput!
    var router: CalendarShowRouter!
    
    var calendarVC: CalendarViewController?
    var schedulerVC: SchedulerViewController?
    var orderDateComponents: DateComponents!
    var orderStartTimeComponents: DateComponents?
    var orderEndTimeComponents: DateComponents?
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
        
        willSet {
            if (newValue == calendarVC) {
                calendarVC!.handlerSelectNewDateCompletion = { newDate in
                    self.dateStackView.isHidden = false
                    self.setupDateLabel(withDate: newDate)
                    self.orderDateComponents = Calendar.current.dateComponents([.month, .day, .year, .hour, .minute], from: newDate)
                }
            }
        }
    }
    
    @IBOutlet weak var bottomDottedBorderView: DottedBorderView! {
        didSet {
            bottomDottedBorderView.style = .AroundDottedRectangle
        }
    }
    
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var confirmButton: FillColorButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var dateLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var fromTimeLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var toTimeLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var dateStackView: UIView!
    
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    
    var handlerConfirmButtonCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CalendarShowConfigurator.sharedInstance.configure(viewController: self)
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarVC = UIStoryboard(name: "CalendarShow", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarViewController
        calendarVC!.selectedDate = Calendar.current.date(from: orderDateComponents)
        schedulerVC = UIStoryboard(name: "CalendarShow", bundle: nil).instantiateViewController(withIdentifier: "SchedulerVC") as? SchedulerViewController
        
        activeViewController = calendarVC
        view.backgroundColor = UIColor.veryDarkDesaturatedBlue24
        dateStackView.isHidden = false
        
        setupScene(withSize: view.frame.size)
        setupSegmentedControlView()
        setupContainerView(withSize: view.frame.size)
        setupDateLabel(withDate: Calendar.current.date(from: orderDateComponents)!)
        
        viewSettingsDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        setupContainerView(withSize: view.frame.size)
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = CalendarShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: CalendarShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")
        
        bottomDottedBorderView.setNeedsDisplay()
        segmentedControlView.setNeedsDisplay()
        containerView.setNeedsDisplay()
        confirmButton.setupWithStyle(.VeryLightOrangeFill)
    }
    
    func setupDateLabel(withDate date: Date) {
        dateLabel.text = date.convertToString(withStyle: .Date)
    }
    
    func setupSegmentedControlView() {
        segmentedControlView.actionButtonHandlerCompletion = { sender in
            self.print(object: "\(type(of: self)): \(#function) run. Sender tag = \(sender.tag)")
            
            switch sender.tag {
            case 1:
                self.activeViewController = self.schedulerVC
                
            default:
                self.activeViewController = self.calendarVC
            }
        }
    }
    
    func setupContainerView(withSize size: CGSize) {
        if (Device.size() == .screen3_5Inch && size.width > size.height) {
            containerLeadingConstraint.constant = 0
            containerTrailingConstraint.constant = 10
            
            containerView.layoutIfNeeded()
        }
    }
    
    func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMove(toParentViewController: nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    func updateActiveViewController() {
        if let activeVC = activeViewController {
            addChildViewController(activeVC)
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            activeVC.didMove(toParentViewController: self)
            activeVC.didMove(toParentViewController: self)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerConfirmButtonTap(_ sender: CustomButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        self.navigationController?.popViewController(animated: true)
        handlerConfirmButtonCompletion!(orderDateComponents)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        print(object: "\(type(of: self)): \(#function) run.")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
}
