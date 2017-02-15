//
//  ForgotPasswordShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol ForgotPasswordShowViewControllerInput {
    func displaySomething(viewModel: ForgotPasswordShow.Something.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol ForgotPasswordShowViewControllerOutput {
    func doSomething(request: ForgotPasswordShow.Something.Request)
}

class ForgotPasswordShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: ForgotPasswordShowViewControllerOutput!
    var router: ForgotPasswordShowRouter!
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textFieldsCollection: [CustomTextField]!
    @IBOutlet weak var phoneEmailErrorMessageView: ErrorMessageView!
    
    @IBOutlet weak var phoneEmailErrorMessageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneEmailErrorMessageViewTopConstraint: NSLayoutConstraint!

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ForgotPasswordShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetupOnLoad()
    }
    
    
    // MARK: - Custom Functions
    func doInitialSetupOnLoad() {
        // UITextFields
        textFieldsArray = textFieldsCollection
        
        // Apply keyboard handler
        scrollViewBase = scrollView
        
        // Hide email error message view
        phoneEmailErrorMessageHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        phoneEmailErrorMessageViewTopConstraint.constant = -Config.Constants.errorMessageViewHeight
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: CustomButton) {
        let textField = textFieldsCollection.last!
        
        if (!textField.checkEmailValidation(textField.text!)) {
            phoneEmailErrorMessageView.didShow(true, withConstraint: phoneEmailErrorMessageViewTopConstraint)
            
            handlerSendButtonCompletion!()
        } else {
            phoneEmailErrorMessageView.didShow(false, withConstraint: phoneEmailErrorMessageViewTopConstraint)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        handlerCancelButtonCompletion!()
    }
}


// MARK: - ForgotPasswordShowViewControllerInput
extension ForgotPasswordShowViewController: ForgotPasswordShowViewControllerInput {
    func displaySomething(viewModel: ForgotPasswordShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}


// MARK: - UITextFieldDelegate
extension ForgotPasswordShowViewController {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if (!(textField as! CustomTextField).checkEmailValidation(textField.text!)) {
            phoneEmailErrorMessageView.didShow(true, withConstraint: phoneEmailErrorMessageViewTopConstraint)
        } else {
            phoneEmailErrorMessageView.didShow(false, withConstraint: phoneEmailErrorMessageViewTopConstraint)
        }
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        phoneEmailErrorMessageView.didShow(false, withConstraint: phoneEmailErrorMessageViewTopConstraint)
        
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (!(textField as! CustomTextField).checkPhoneEmailValidation(textField.text!)) {
            phoneEmailErrorMessageView.didShow(true, withConstraint: phoneEmailErrorMessageViewTopConstraint)
            
            return false
        } else {
            phoneEmailErrorMessageView.didShow(false, withConstraint: phoneEmailErrorMessageViewTopConstraint)
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        phoneEmailErrorMessageView.didShow(false, withConstraint: phoneEmailErrorMessageViewTopConstraint)
        
        return true
    }
}
