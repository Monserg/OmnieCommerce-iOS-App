//
//  NewPhoneView.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class NewPhoneView: UIView {
    // MARK: - Properties
    var handlerDeleteButtonCompletion: HandlerSendButtonCompletion?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var dottedBorderView: DottedBorderView!
    @IBOutlet weak var phoneTextField: CustomTextField!
    @IBOutlet weak var deleteButton: FillVeryLightOrangeButton!
    
    @IBOutlet weak var errorMessageView: ErrorMessageView!
    
    @IBOutlet weak var errorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorMessageViewHeightConstraint: NSLayoutConstraint!
    
    
//    var handlerDeleteButtonTap: handlerdele
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: NewPhoneView.self), bundle: Bundle(for: NewPhoneView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame          =   frame
        alpha               =   0
        tag                 =   0
        phoneTextField.tag  =   tag
        deleteButton.tag    =   tag
    }
    
    
    // MARK: - Actions
    @IBAction func handlerDeleteButtonTap(_ sender: FillVeryLightOrangeButton) {
        handlerDeleteButtonCompletion!()
    }
    
}
