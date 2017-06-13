//
//  PhonesView.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhonesView: CustomView {
    // MARK: - Properties
    var isShow: Bool = false
    let phoneNumberKit = PhoneNumberKit()
    
    var handlerPhonesFormatErrorCompletion: HandlerCancelButtonCompletion?
    
    @IBOutlet var view: UIView!
    @IBOutlet var phoneButtonsCollection: [CustomButton]!
    

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
        guard (values?.count)! > 0 else {
            return
        }
        
        // Prepare phones stack view
        var phoneNumbers = phoneNumberKit.parse(values as! [String])

        if (phoneNumbers.count > 0) {
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                phoneNumbers = phoneNumberKit.parse(values as! [String], withRegion: countryCode,  ignoreType: true)
            }
            
            for (index, button) in phoneButtonsCollection.enumerated() {
                if (index <= (values?.count)! - 1) {
                    // Phone format: +61 2 3661 8300
                    let phoneNumber = phoneNumberKit.format(phoneNumbers[index], toType: .international)
                    
                    button.setAttributedTitle(NSAttributedString(string: phoneNumber, attributes: UIFont.ubuntuRegularSoftOrange21), for: .normal)
                    button.setAttributedTitle(NSAttributedString(string: phoneNumber, attributes: UIFont.ubuntuRegularSoftOrange21Alpha30), for: .highlighted)
                } else {
                    button.alpha = 0
                }
            }
        } else {
            didHide()
            handlerPhonesFormatErrorCompletion!()
        }
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
        UINib(nibName: String(describing: PhonesView.self), bundle: Bundle(for: PhonesView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPhoneButtonTap(_ sender: CustomButton) {
        let phone = "tel://";
        let str = sender.attributedTitle(for: .normal)?.string
        let url = URL(string: phone + str!.replacingOccurrences(of: " ", with: ""))
        
        guard url != nil else {
            return
        }
        
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
