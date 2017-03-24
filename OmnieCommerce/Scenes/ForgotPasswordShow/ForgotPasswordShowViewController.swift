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
    func codeDidShow(fromViewModel viewModel: ForgotPasswordShowModels.Code.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol ForgotPasswordShowViewControllerOutput {
    func codeDidLoad(fromRequestModel requestModel: ForgotPasswordShowModels.Code.RequestModel)
}

class ForgotPasswordShowViewController: BaseViewController, EmailErrorMessageView {
    // MARK: - Properties
    var interactor: ForgotPasswordShowViewControllerOutput!
    var router: ForgotPasswordShowRouter!
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
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

    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: ErrorMessageView!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view.layoutIfNeeded()

        ForgotPasswordShowConfigurator.sharedInstance.configure(viewController: self)
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
        textFieldManager = MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC = self
        
        // Hide email error message view
        emailErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        emailErrorMessageView.didShow(false, withConstraint: emailErrorMessageViewTopConstraint)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerSendButtonTap(_ sender: CustomButton) {
        if (textFieldManager.checkTextFieldCollection()) {
            guard isNetworkAvailable else {
                return
            }

            let data: (phone: String?, email: String?) = (textFieldsCollection.first!.isPhone!) ? (phone: textFieldsCollection.first!.text!, email: nil) : (phone: nil, email: textFieldsCollection.first!.text!)
            
            spinnerDidStart(view)
            
            let forgotPasswordRequestModel = ForgotPasswordShowModels.Code.RequestModel(data: data)
            interactor.codeDidLoad(fromRequestModel: forgotPasswordRequestModel)
        } else {
            emailErrorMessageView.didShow(true, withConstraint: emailErrorMessageViewTopConstraint)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        guard isNetworkAvailable else {
            return
        }

        handlerCancelButtonCompletion!()
    }
}


// MARK: - ForgotPasswordShowViewControllerInput
extension ForgotPasswordShowViewController: ForgotPasswordShowViewControllerInput {
    func codeDidShow(fromViewModel viewModel: ForgotPasswordShowModels.Code.ViewModel) {
        spinnerDidFinish()

        guard isNetworkAvailable else {
            return
        }

        if (viewModel.code == 200) {
            UserDefaults.standard.set(textFieldsCollection.first!.text!, forKey: keyEmail)
            handlerSendButtonCompletion!()
        } else {
            alertViewDidShow(withTitle: "Error", andMessage: "Wrong input data", completion: { _ in })
        }
    }
}
