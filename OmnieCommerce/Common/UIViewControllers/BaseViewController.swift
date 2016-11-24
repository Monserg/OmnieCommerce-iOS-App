//
//  BaseViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift
import SWRevealViewController

class BaseViewController: UIViewController {
    // MARK: - Properties
    var selectedRange: CGRect?
    var topBarViewRounding = CircleView.CirleRadius.small
    let scrollView = UIScrollView()
    var content = UIView()
    var topBarViewHeight: CGFloat = 100.0
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Actions
    func handleKeyboardAction(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == .UIKeyboardWillHide {
            if (NSStringFromClass(type(of: self)).hasSuffix("ForgotPasswordShowViewController")) {
                let forgotPasswordShowVC = self as! ForgotPasswordShowViewController

                if (!forgotPasswordShowVC.phoneEmailTextField.isValidEmail(forgotPasswordShowVC.phoneEmailTextField.text!) && !(forgotPasswordShowVC.phoneEmailTextField.text?.isEmpty)!) {
                    forgotPasswordShowVC.phoneEmailErrorLabel.isHidden = false
                }
            }

            scrollView.contentInset = UIEdgeInsets(top: -topBarViewHeight, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.showsVerticalScrollIndicator = false
        
        guard selectedRange != nil else {
            return
        }
        
        scrollView.scrollRectToVisible(selectedRange!, animated: true)
    }
    
    
    // MARK: - Custom Functions
    func setup(topBarView: TopBarView) {
        // .small radius
        if (topBarViewRounding == .small) {
            print(".small")
            
            let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
        }
        
        // .big radius
        else {
            // Set background color
            self.view.backgroundColor = Config.Colors.veryDarkDesaturatedBlue24

            // Add Slide Menu actions
            if revealViewController() != nil {
                topBarView.actionButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                
                // Sidebar is width 296
                revealViewController().rearViewRevealWidth = 296
                
                revealViewController().rearViewRevealDisplacement = 198
                
                revealViewController().rearViewRevealOverdraw = 0
                
                // Faster slide animation
                revealViewController().toggleAnimationDuration = 0.3
                
                // Simply ease out. No Spring animation.
                revealViewController().toggleAnimationType = .easeOut
                
                // More shadow
                revealViewController().frontViewShadowRadius = 5
                revealViewController().frontViewShadowColor = UIColor.white

                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        // Setup UIScrollView
        scrollView.frame = CGRect.init(x: 0, y: topBarView.frame.height, width: view.bounds.width, height: view.bounds.height - topBarView.bounds.height)
        scrollView.delegate = self
        scrollView.contentSize = scrollView.frame.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentOffset = CGPoint.init(x: 0, y: topBarViewHeight)

        content.translatesAutoresizingMaskIntoConstraints = true
        scrollView.addSubview(content)
        view.addSubview(scrollView)
    }
}


// MARK: - UIScrollViewDelegate
extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}


// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate
extension BaseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (NSStringFromClass(type(of: self)).hasSuffix("ForgotPasswordShowViewController")) {
            let forgotPasswordShowVC = self as! ForgotPasswordShowViewController
            
            if (!forgotPasswordShowVC.phoneEmailErrorLabel.isHidden) {
                forgotPasswordShowVC.phoneEmailErrorLabel.isHidden = true
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! CustomTextField).attributedPlaceholderString = textField.attributedPlaceholder
        textField.placeholder = nil
        selectedRange = textField.convert(textField.bounds, to: view)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = (textField as! CustomTextField).attributedPlaceholderString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (NSStringFromClass(type(of: self)).hasSuffix("SignInShowViewController")) {
            let signInShowVC = self as! SignInShowViewController
            
            if textField == signInShowVC.nameTextField {
                signInShowVC.passwordTextField.becomeFirstResponder()
            } else {
                // FIXME: RUN LOGIN FUNC
                print("login run.")
                textField.resignFirstResponder()
            }
        }

        else if (NSStringFromClass(type(of: self)).hasSuffix("SignUpShowViewController")) {
            let signUpShowVC = self as! SignUpShowViewController
            
            if textField == signUpShowVC.nameTextField {
                signUpShowVC.emailTextField.becomeFirstResponder()
            } else if textField == signUpShowVC.emailTextField {
                if (textField.isValidEmail(textField.text!)) {
                    signUpShowVC.passwordTextField.becomeFirstResponder()
                }
            } else {
                // FIXME: RUN LOGIN FUNC
                print("login run.")
                textField.resignFirstResponder()
            }
        }

        else if (NSStringFromClass(type(of: self)).hasSuffix("ForgotPasswordShowViewController")) {
            let forgotPasswordShowVC = self as! ForgotPasswordShowViewController
            
            if (textField.isValidEmail(textField.text!)) {
                forgotPasswordShowVC.phoneEmailErrorLabel.isHidden = true
                textField.resignFirstResponder()
                
                // TODO: - RUN SEND BUTTON HANDLER
            } else {
                forgotPasswordShowVC.phoneEmailErrorLabel.isHidden = false
 
                return false
            }
        }

        return true
    }
}
