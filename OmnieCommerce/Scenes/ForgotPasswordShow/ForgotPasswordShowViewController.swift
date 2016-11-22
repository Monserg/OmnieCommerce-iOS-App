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

// MARK: - Input & Output protocols
protocol ForgotPasswordShowViewControllerInput {
    func displaySomething(viewModel: ForgotPasswordShow.Something.ViewModel)
}

protocol ForgotPasswordShowViewControllerOutput {
    func doSomething(request: ForgotPasswordShow.Something.Request)
}

class ForgotPasswordShowViewController: BaseViewController, ForgotPasswordShowViewControllerInput {
    // MARK: - Properties
    var output: ForgotPasswordShowViewControllerOutput!
    var router: ForgotPasswordShowRouter!
    
    @IBOutlet var topBarView: TopBarView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phoneEmailTextField: CustomTextField!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ForgotPasswordShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        phoneEmailTextField.delegate = self
        
        content = contentView
        
        setup(topBarView: topBarView)

        doSomethingOnLoad()
    }
    
    deinit {
        print("ForgotPasswordShowViewController deinit.")
    }


    // MARK: - Actions
    @IBAction func handleSendButtonTap(_ sender: CustomButton) {
    }
    
    @IBAction func handleCancelButtonTap(_ sender: CustomButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = ForgotPasswordShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: ForgotPasswordShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
