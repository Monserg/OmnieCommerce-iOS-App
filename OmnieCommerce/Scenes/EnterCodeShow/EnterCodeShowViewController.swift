//
//  EnterCodeShowViewController.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 07.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol EnterCodeShowViewControllerInput {}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol EnterCodeShowViewControllerOutput {}

class EnterCodeShowViewController: BaseViewController, CodeErrorMessageView {
    // MARK: - Properties
    var interactor: EnterCodeShowViewControllerOutput!
    var router: EnterCodeShowRouter!
    
    var enteredCode: String!
    var isInputCodeValid = false
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    var textFieldManager: TextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var codeErrorMessageView: UIView!
    
    @IBOutlet var textFieldsCollection: [CustomTextField]!
    
    @IBOutlet weak var codeErrorMessageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeErrorMessageViewTopConstraint: NSLayoutConstraint!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layoutIfNeeded()

        EnterCodeShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetupOnLoad()
    }
    

    // MARK: - Custom Functions
    func doInitialSetupOnLoad() {
        // Apply keyboard handler
        scrollViewBase = scrollView
        
        // Create TextFieldManager
        textFieldManager = TextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC = self
        
        // Hide email error message view
        codeErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(codeErrorMessageView, withConstraint: codeErrorMessageViewTopConstraint)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: CustomButton) {
        guard let text = textFieldsCollection.last?.text else {
            return
        }
        
        if (text == enteredCode) {
            handlerSendButtonCompletion!()
        } else {
            didShow(codeErrorMessageView, withConstraint: codeErrorMessageViewTopConstraint)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        handlerCancelButtonCompletion!()
    }
    
    @IBAction func handlerSendAgainButtonTap(_ sender: CustomButton) {}
}


// MARK: - ForgotPasswordShowViewControllerInput
extension EnterCodeShowViewController: EnterCodeShowViewControllerInput {}
