//
//  SignUpShowViewController.swift
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
protocol SignUpShowViewControllerInput {
    func didShowPasswordTextFieldCheckResult(fromViewModel viewModel: SignUpShowModels.PasswordTextField.ViewModel)
    func didShowShowRegisterUserResult(fromViewModel viewModel: SignUpShowModels.User.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol SignUpShowViewControllerOutput {
    func didValidatePasswordTextFieldStrength(fromRequestModel requestModel: SignUpShowModels.PasswordTextField.RequestModel)
    func didRegisterUser(fromRequestModel requestModel: SignUpShowModels.User.RequestModel)
}

class SignUpShowViewController: BaseViewController, EmailErrorMessageView, PasswordStrengthView, PasswordStrengthErrorMessageView {
    // MARK: - Properties
    var interactor: SignUpShowViewControllerOutput!
    var router: SignUpShowRouter!
    
    var textFieldManager: TextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }
    
    var handlerRegisterButtonCompletion: HandlerRegisterButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    var passwordStrengthLevel: PasswordStrengthLevel = .None

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailErrorMessageView: UIView!
    @IBOutlet weak var passwordStrengthErrorMessageView: UIView!
    @IBOutlet weak var passwordStrengthView: PasswordStrengthLevelView!

    @IBOutlet var textFieldsCollection: [CustomTextField]!

    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthErrorMessageViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layoutIfNeeded()

        SignUpShowConfigurator.sharedInstance.configure(viewController: self)
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
        emailErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)
        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
        passwordStrengthView.passwordStrengthLevel = .None
    }
        
    
    // MARK: - Actions
    @IBAction func handlerRegisterButtonTap(_ sender: CustomButton) {
        if (textFieldManager.checkTextFieldCollection()) {
            guard isNetworkAvailable else {
                alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
                
                return
            }
            
            let requestModel = SignUpShowModels.User.RequestModel(name: textFieldsCollection.first!.text!, email: textFieldsCollection[1].text!, password: textFieldsCollection.last!.text!)
            interactor.didRegisterUser(fromRequestModel: requestModel)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }
        
        handlerCancelButtonCompletion!()
    }
}


// MARK: - SignUpShowViewControllerInput
extension SignUpShowViewController: SignUpShowViewControllerInput {
    func didShowPasswordTextFieldCheckResult(fromViewModel: SignUpShowModels.PasswordTextField.ViewModel) {
        //        passwordCheckResult?.strengthLevel = viewModel.strengthLevel
        //        passwordCheckResult?.isValid = viewModel.isValid
        //        passwordStrengthView.passwordStrengthLevel = viewModel.strengthLevel
    }
    
    func didShowShowRegisterUserResult(fromViewModel viewModel: SignUpShowModels.User.ViewModel) {
        guard viewModel.result.error == nil else {
            alertViewDidShow(withTitle: "Error".localized(), andMessage: (viewModel.result.error?.description)!)
            
            return
        }
        
        CoreDataManager.instance.didUpdateAppUser(state: true)
        
        handlerRegisterButtonCompletion!()
        
        // Clear all text fields
        _ = textFieldsCollection.map{ $0.text = nil }
    }
}
