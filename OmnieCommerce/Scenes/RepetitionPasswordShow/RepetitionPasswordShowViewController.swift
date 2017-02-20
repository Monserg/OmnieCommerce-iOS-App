//
//  RepetitionPasswordShowViewController.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 08.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol RepetitionPasswordShowViewControllerInput {
    func displaySomething(viewModel: RepetitionPasswordShowModels.Something.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol RepetitionPasswordShowViewControllerOutput {
    func doSomething(requestModel: RepetitionPasswordShowModels.Something.RequestModel)
}

class RepetitionPasswordShowViewController: BaseViewController, PasswordStrengthView, PasswordStrengthErrorMessageView, PasswordErrorMessageView {
    // MARK: - Properties
    var interactor: RepetitionPasswordShowViewControllerOutput!
    var router: RepetitionPasswordShowRouter!
    
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
    @IBOutlet var textFieldsCollection: [CustomTextField]!

    // Protocol PasswordStrengthView, PasswordStrengthErrorMessageView
    @IBOutlet weak var passwordStrengthView: PasswordStrengthLevelView!
    @IBOutlet weak var passwordStrengthErrorMessageView: UIView!
    @IBOutlet weak var passwordStrengthErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthErrorMessageViewHeightConstraint: NSLayoutConstraint!

    // Protocol PasswordErrorMessageView
    @IBOutlet weak var passwordErrorMessageView: UIView!
    @IBOutlet weak var passwordErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layoutIfNeeded()

        RepetitionPasswordShowConfigurator.sharedInstance.configure(viewController: self)
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
        passwordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
        passwordStrengthView.passwordStrengthLevel = .None
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: CustomButton) {
        if (textFieldsCollection.first?.text == textFieldsCollection.last?.text) {
            CoreDataManager.instance.didUpdateAppUser(state: true)
            
            handlerSendButtonCompletion!()
        } else {
            didShow(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        handlerCancelButtonCompletion!()
    }
}


// MARK: - ForgotPasswordShowViewControllerInput
extension RepetitionPasswordShowViewController: RepetitionPasswordShowViewControllerInput {
    func displaySomething(viewModel: RepetitionPasswordShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
