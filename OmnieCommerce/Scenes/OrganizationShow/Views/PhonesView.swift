//
//  PhonesView.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PhonesView: CustomView {
    // MARK: - Properties
    var phones: [String]?
    var isShow: Bool = false
    
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    @IBOutlet var view: UIView!
    @IBOutlet var phoneButtonsCollection: [CustomButton]!
    

    // MARK: - Class Initialization
    init(inView view: UIView) {
        super.init(frame: view.frame)
        
        createFromXIB()

        let widthRatio      =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / view.frame.width
        let heightRatio     =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / view.frame.height
        self.frame          =   CGRect.init(x: 0, y: 0, width: 345 * widthRatio, height: 185 * heightRatio)
        self.alpha          =   0
        
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
        guard (phones?.count)! > 0 else {
            return
        }
        
        // Prepare phones stack view
        for (index, button) in phoneButtonsCollection.enumerated() {
            if (index <= (phones?.count)! - 1) {
                button.setAttributedTitle(NSAttributedString(string: phones![index], attributes: UIFont.ubuntuRegularSoftOrange21), for: .normal)
                button.setAttributedTitle(NSAttributedString(string: phones![index], attributes: UIFont.ubuntuRegularSoftOrange21Alpha30), for: .highlighted)
            } else {
                button.alpha    =   0
            }
        }
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
        UINib(nibName: String(describing: PhonesView.self), bundle: Bundle(for: PhonesView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPhoneButtonTap(_ sender: CustomButton) {
        let phone   =   "tel://";
        let str     =   sender.attributedTitle(for: .normal)?.string
        let url     =   URL(string: phone + str!)
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
}
