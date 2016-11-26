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

enum TopBarViewStyle {
    case Big
    case Small
}
class BaseViewController: UIViewController {
    // MARK: - Properties
    var selectedRange: CGRect?
    var topBarViewStyle = TopBarViewStyle.Big
    var scrollViewBase = UIScrollView()
    
///    var contentViewBase = UIView()
///    var topBarViewHeight: CGFloat = 100.0
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        print(object: "\(type(of: self)): \(#function) run. View size = \(view.bounds.size)")
        
        super.viewDidLoad()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(object: "\(type(of: self)): \(#function) run.")

        super.viewWillAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print(object: "\(type(of: self)): \(#function) run.")
    }

    
    // MARK: - Actions
    func handleKeyboardAction(notification: Notification) {
        print(object: "\(type(of: self)): \(#function) run.")
        
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

            scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
        }
        
        scrollViewBase.scrollIndicatorInsets = scrollViewBase.contentInset
        scrollViewBase.showsVerticalScrollIndicator = false
        
        guard (selectedRange != nil && (keyboardViewEndFrame.contains((selectedRange?.origin)!))) else {
            return
        }

        scrollViewBase.scrollRectToVisible(selectedRange!, animated: true)
    }
    
    
    // MARK: - Custom Functions
    func setup(topBarView: UIView) {
        print(object: "\(type(of: self)): \(#function) run.")

        // TopBarView big height
        if (topBarViewStyle == .Big) {
            let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
        }
        
        // TopBarView small height
        else {
            // Set background color
            self.view.backgroundColor = Config.Colors.veryDarkDesaturatedBlue24

            // Add Slide Menu actions
            if revealViewController() != nil {
//                self.topBarView.actionButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                
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
//        scrollViewBase.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - topBarView.bounds.height)
//        scrollViewBase.delegate = self
        //scrollViewBase.contentSize = CGSize.init(width: 60, height: 2000)
//        scrollViewBase.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        scrollViewBase.contentOffset = CGPoint.init(x: 0, y: topBarViewHeight)

//        contentViewBase.translatesAutoresizingMaskIntoConstraints = false
//        scrollViewBase.addSubview(contentViewBase)
//        view.addSubview(scrollViewBase)
    }
    
    
    // MARK: - Custom Functions
    func releasePrint(object: Any) {
        Swift.print(object)
    }
    
    func print(object: Any) {
        #if DEBUG
            Swift.print(object)
        #endif
    }
}


// MARK: - UIScrollViewDelegate
extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(object: "\(type(of: self)): \(#function) run. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
    }
}


// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print(object: "\(type(of: self)): \(#function) run.")
        
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
        print(object: "\(type(of: self)): \(#function) run.")
        
        (textField as! CustomTextField).attributedPlaceholderString = textField.attributedPlaceholder
        textField.placeholder = nil
        selectedRange = textField.convert(textField.bounds, to: view)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        textField.attributedPlaceholder = (textField as! CustomTextField).attributedPlaceholderString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(object: "\(type(of: self)): \(#function) run. Owner = \(self)")
        
        if (NSStringFromClass(type(of: self)).hasSuffix("SignInShowViewController")) {
            let signInShowVC = self as! SignInShowViewController
            
            if textField == signInShowVC.nameTextField {
                signInShowVC.passwordTextField.becomeFirstResponder()
            } else {
                // FIXME: RUN LOGIN FUNC
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
