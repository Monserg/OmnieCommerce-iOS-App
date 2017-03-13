//
//  SignInContainerShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol SignInContainerShowViewControllerInput {
    func userAppDidShow(fromViewModel viewModel: SignInContainerShowModels.User.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol SignInContainerShowViewControllerOutput {
    func userAppDidSignIn(withRequestModel requestModel: SignInContainerShowModels.User.RequestModel)
}

class SignInContainerShowViewController: BaseViewController, PasswordErrorMessageView {
    // MARK: - Properties
    var interactor: SignInContainerShowViewControllerOutput!
    var router: SignInContainerShowRouter!
    
    var textFieldManager: MSMTextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }
    
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    var handlerRegisterButtonCompletion: HandlerRegisterButtonCompletion?
    var handlerForgotPasswordButtonCompletion: HandlerForgotPasswordButtonCompletion?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textFieldsCollection: [CustomTextField]!
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map{ $0.style = .BottomDottedLine }
        }
    }

    // Protocol PasswordErrorMessageView
    @IBOutlet weak var passwordErrorMessageView: UIView!
    @IBOutlet weak var passwordErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layoutIfNeeded()

        SignInContainerShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Apply keyboard handler
        scrollViewBase              =   scrollView
        
        didAddTapGestureRecognizer()

        // Create MSMTextFieldManager
        textFieldManager            =   MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC  =   self
        
        // Hide email error message view
        passwordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
    }
    
    func didCleanTextFields() {
        _ = textFieldsCollection.map{ $0.text = nil }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerRegisterButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }
                
        handlerRegisterButtonCompletion!()
    }
    
    @IBAction func handlerForgotPasswordButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }

        handlerForgotPasswordButtonCompletion!()
    }
    
    @IBAction func handlerSignInButtonTap(_ sender: CustomButton) {
        // User authorization
        guard let name = textFieldsCollection.first?.text, let password = textFieldsCollection.last?.text, !(name.isEmpty), !(password.isEmpty) else {
            alertViewDidShow(withTitle: "Info".localized(), andMessage: "All fields can be...".localized())
            
            return
        }
        
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }

        let requestModel    =   SignInContainerShowModels.User.RequestModel(name: name, password: password)
        interactor.userAppDidSignIn(withRequestModel: requestModel)
    }
}


// MARK: - SignInContainerShowViewControllerInput
extension SignInContainerShowViewController: SignInContainerShowViewControllerInput {
    func userAppDidShow(fromViewModel viewModel: SignInContainerShowModels.User.ViewModel) {
        guard viewModel.responseAPI != nil && viewModel.responseAPI?.code != 4401 && viewModel.responseAPI?.code != 4500 else {
            alertViewDidShow(withTitle: "Error".localized(),
                             andMessage: ((viewModel.responseAPI?.code == 4401) ? "Authentication failure" : "Wrong input data").localized())
            
            return
        }
        
        // Mofidy AppUser properties
        CoreDataManager.instance.didUpdateAppUser(state: true)
        CoreDataManager.instance.appUser.appName        =   self.textFieldsCollection.first?.text!
        CoreDataManager.instance.appUser.password       =   self.textFieldsCollection.last?.text!
        CoreDataManager.instance.appUser.accessToken    =   viewModel.responseAPI!.accessToken
        CoreDataManager.instance.didSaveContext()
        
        handlerPassDataCompletion!(viewModel.responseAPI!.code!)
        
        // Clear all text fields
        self.didCleanTextFields()
    }
}
