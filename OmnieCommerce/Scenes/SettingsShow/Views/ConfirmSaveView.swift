//
//  ConfirmSaveView.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ConfirmSaveView: CustomView {
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var messageLabel: UbuntuLightVeryLightGrayLabel!
    
    
    // MARK: - Class Initialization
    init(inView view: UIView, withText text: String) {
        let newFrame = CGRect.init(origin: .zero, size: view.frame.size)
        super.init(frame: newFrame)
        
        createFromXIB()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.messageLabel.text = text.localized()
        
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
    }
    
    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
        })
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: ConfirmSaveView.self), bundle: Bundle(for: ConfirmSaveView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
        handlerCancelButtonCompletion!()
    }
}
