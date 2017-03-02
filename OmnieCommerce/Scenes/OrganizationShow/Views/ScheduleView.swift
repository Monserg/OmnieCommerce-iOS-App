//
//  ScheduleView.swift
//  OmnieCommerce
//
//  Created by msm72 on 02.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ScheduleView: CustomView {
    // MARK: - Properties
    var schedule: Schedule!
    var isShow: Bool    =   false
    
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var mondayLabel: CustomLabel!
    @IBOutlet weak var saturdayLabel: CustomLabel!
    @IBOutlet weak var sundayLabel: CustomLabel!
    @IBOutlet weak var launchLabel: CustomLabel!
    
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        super.init(frame: view.frame)
        
        createFromXIB()
        
        let widthRatio          =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / view.frame.width
        let heightRatio         =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / view.frame.height
        self.frame              =   CGRect.init(x: 0, y: 0, width: 345 * widthRatio, height: 185 * heightRatio)
        self.alpha              =   0
        self.backgroundColor    =   UIColor.clear
        self.layer.cornerRadius =   5
        self.clipsToBounds      =   true
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints   =   false
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  =   true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  =   true
        
        self.didShow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Prepare schedule labels
//        mondayLabel.text        =   schedule.timeWork
//        saturdayLabel.text      =   schedule.timeSaturday
//        sundayLabel.text        =   schedule.timeSunday
//        launchLabel.text        =   schedule.timeLaunch
    }
    
    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha          =   0
        }, completion: { success in
            self.removeFromSuperview()
            
            self.handlerCancelButtonCompletion!()
        })
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: ScheduleView.self), bundle: Bundle(for: ScheduleView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame  =   frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
}
