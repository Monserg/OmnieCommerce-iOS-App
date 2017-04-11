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
    var isShow: Bool = false
    
    override var values: [Any]? {
        didSet {
//            weekdaysWorkLabel.text = (values as! Schedule).day.convertToScheduleString()
//            weekdaysWorkTimeLabel.text = (values as? Schedule).workTimeStart + " - " + (values as? Schedule).workTimeEnd
        }
    }

    @IBOutlet var view: UIView!
    @IBOutlet weak var weekdaysWorkLabel: UbuntuLightSoftOrangeLabel!
    @IBOutlet weak var weekdaysWorkTimeLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet weak var saturdayLabel: CustomLabel!
    @IBOutlet weak var sundayLabel: CustomLabel!
    @IBOutlet weak var launchLabel: CustomLabel!
    
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        let newFrame = CGRect.init(origin: .zero, size: view.frame.size)
        super.init(frame: newFrame)
        
        createFromXIB()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        view.addSubview(self)
        self.didShow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Prepare schedule labels
    }
    
    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
            self.handlerCancelButtonCompletion!()
        })
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: ScheduleView.self), bundle: Bundle(for: ScheduleView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
}
