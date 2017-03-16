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
    func newPasswordDidShow(fromViewModel viewModel: RepetitionPasswordShowModels.Password.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol RepetitionPasswordShowViewControllerOutput {
    func newPasswordDidChange(fromRequestModel requestModel: RepetitionPasswordShowModels.Password.RequestModel)
}

class RepetitionPasswordShowViewController: BaseViewController, PasswordStrengthView, PasswordStrengthErrorMessageView, PasswordErrorMessageView {
    // MARK: - Properties
    var interactor: RepetitionPasswordShowViewControllerOutput!
    var router: RepetitionPasswordShowRouter!
    
    var email: String!
    var resetToken: String!
    
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    var textFieldManager: MSMTextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }

    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map{ $0.style = .BottomDottedLine }
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
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Apply keyboard handler
        scrollViewBase = scrollView
        
        didAddTapGestureRecognizer()

        // Create MSMTextFieldManager
        textFieldManager            =   MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC  =   self
        
        // Hide email error message view
        passwordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
        passwordStrengthView.passwordStrengthLevel = .None
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: CustomButton) {
        if (textFieldsCollection.first?.text == textFieldsCollection.last?.text) {
            guard isNetworkAvailable else {
                alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
                return
            }
         
            let requestModel    =   RepetitionPasswordShowModels.Password.RequestModel(email: email, newPassword: textFieldsCollection.first!.text!, resetToken: resetToken)
            interactor.newPasswordDidChange(fromRequestModel: requestModel)
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


// MARK: - ForgotPasswordShowViewControllerInput
extension RepetitionPasswordShowViewController: RepetitionPasswordShowViewControllerInput {
    func newPasswordDidShow(fromViewModel viewModel: RepetitionPasswordShowModels.Password.ViewModel) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            return
        }
        
        if (viewModel.response?.code == 200) {
            CoreDataManager.instance.didUpdateAppUser(state: true)
            CoreDataManager.instance.appUser.email = email
            CoreDataManager.instance.appUser.password = textFieldsCollection.first!.text!
            CoreDataManager.instance.appUser.accessToken = viewModel.response!.body
            CoreDataManager.instance.didSaveContext()
            
            handlerPassDataCompletion!(viewModel.response!.code)
        } else {
            didShow(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
        }
    }
}
