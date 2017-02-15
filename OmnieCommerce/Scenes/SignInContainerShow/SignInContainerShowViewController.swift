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
    func displaySomething(viewModel: SignInContainerShowModels.User.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol SignInContainerShowViewControllerOutput {
    func didUserSignIn(requestModel: SignInContainerShowModels.User.RequestModel)
}

class SignInContainerShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: SignInContainerShowViewControllerOutput!
    var router: SignInContainerShowRouter!
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerRegisterButtonCompletion: HandlerRegisterButtonCompletion?
    var handlerForgotPasswordButtonCompletion: HandlerForgotPasswordButtonCompletion?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textFieldsCollection: [CustomTextField]!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SignInContainerShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetupOnLoad()
    }
    

    // MARK: - Custom Functions
    func doInitialSetupOnLoad() {
        // Delegates
        textFieldsArray = textFieldsCollection
        
        // Apply keyboard handler
        scrollViewBase = scrollView
    }
    
    
    // MARK: - Actions
    @IBAction func handlerRegisterButtonTap(_ sender: CustomButton) {
        handlerRegisterButtonCompletion!()
    }
    
    @IBAction func handlerForgotPasswordButtonTap(_ sender: CustomButton) {
        handlerForgotPasswordButtonCompletion!()
    }
    
    @IBAction func handlerSignInButtonTap(_ sender: CustomButton) {
        // NOTE: Ask the Interactor to do some work
        guard let name = textFieldsCollection.first?.text, let password = textFieldsCollection.last?.text, !(name.isEmpty), !(password.isEmpty) else {
            // TODO: - ADD ALERT
            showAlertView(withTitle: "Info".localized(), andMessage: "All fields can be...".localized())
            
            return
        }
        
        let requestModel = SignInContainerShowModels.User.RequestModel(name: name, password: password)
        interactor.didUserSignIn(requestModel: requestModel)
    }
}


// MARK: - SignInContainerShowViewControllerInput
extension SignInContainerShowViewController: SignInContainerShowViewControllerInput {
    func displaySomething(viewModel: SignInContainerShowModels.User.ViewModel) {
        guard viewModel.result.error == nil else {
            // TODO: - ADD ALERT
            showAlertView(withTitle: "Error".localized(), andMessage: "This user not register...".localized())
            
            return
        }
        
        handlerSendButtonCompletion!()
    }
}
