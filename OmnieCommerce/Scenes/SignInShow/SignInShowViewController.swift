//
//  SignInShowViewController.swift
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
protocol SignInShowViewControllerInput {
    func displaySomething(viewModel: SignInShow.Something.ViewModel)
}

protocol SignInShowViewControllerOutput {
    func doSomething(request: SignInShow.Something.Request)
}

class SignInShowViewController: BaseViewController, SignInShowViewControllerInput {
    // MARK: - Properties
    var output: SignInShowViewControllerOutput!
    var router: SignInShowRouter!
    
    @IBOutlet var topBarView: TopBarView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var vkontakteButton: CustomButton!
    @IBOutlet weak var googleButton: CustomButton!
    @IBOutlet weak var facebookButton: CustomButton!
    
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var topBarViewHeightPortraitConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarViewHeightLandscapeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SignInShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        nameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Config scene
        topBarView.circleView.cirleRadiusStyle = .small
        topBarViewHeight = (topBarView.circleView.cirleRadiusStyle == .small) ? Config.Constants.topViewBarHeightSmall : Config.Constants.topViewBarHeightBig
        topBarViewHeightPortraitConstraint.constant = topBarViewHeight
        topBarViewHeightLandscapeConstraint.constant = topBarViewHeight
        self.view.layoutIfNeeded()
        
        // Set buttons type
        vkontakteButton.type = .social
        googleButton.type = .social
        facebookButton.type = .social
        
        content = contentView
        
        setup(topBarView: topBarView)
        
        doSomethingOnLoad()
    }
        
    deinit {
        print("SignInShowViewController deinit.")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            print("Landscape")
            
            topBarView.center = CGPoint(x: topBarViewHeight / 2, y: UIScreen.main.bounds.height / 2)
        } else {
            print("Portrait")
            
            topBarView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: topBarViewHeight / 2)
        }
        
        topBarView.setNeedsDisplay()
        
        if (topBarView.circleView.cirleRadiusStyle == .small) {
            vkontakteButton.setNeedsDisplay()
            googleButton.setNeedsDisplay()
            facebookButton.setNeedsDisplay()
        } else {
            vkontakteButton.isHidden = true
            googleButton.isHidden = true
            facebookButton.isHidden = true
        }
    }

    
    // MARK: - Actions
    @IBAction func unwindToSignInShow(_ segue: UIStoryboardSegue) {}

    @IBAction func asdasdasd(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = SignInShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: SignInShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}


// MARK: - UITextFieldDelegate
extension SignInShowViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
        selectedRange = textField.convert(textField.bounds, to: view)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            // FIXME: RUN LOGIN FUNC
            print("login run.")
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = (textField as! CustomTextField).attributedPlaceholderText
    }
}
