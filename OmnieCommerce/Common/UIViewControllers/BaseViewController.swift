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
        
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        super.awakeFromNib()
    }

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. View size = \(view.bounds.size)")
        
        super.viewDidLoad()
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAction), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")

        super.viewWillAppear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
    }

    
    // MARK: - Actions
    func handleKeyboardAction(notification: Notification) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if (notification.name == .UIKeyboardWillHide) {
            if (NSStringFromClass(type(of: self)).hasSuffix("ForgotPasswordShowViewController")) {
                let forgotPasswordShowVC = self as! ForgotPasswordShowViewController

                if (!forgotPasswordShowVC.phoneEmailTextField.isValidEmail(forgotPasswordShowVC.phoneEmailTextField.text!) && !(forgotPasswordShowVC.phoneEmailTextField.text?.isEmpty)!) {
                    forgotPasswordShowVC.phoneEmailErrorLabel.isHidden = false
                }
            } else if (NSStringFromClass(type(of: self)).hasSuffix("SignUpShowViewController")) {
                let signUpShowVC = self as! SignUpShowViewController
                
                if (!signUpShowVC.emailTextField.isValidEmail(signUpShowVC.emailTextField.text!) && !(signUpShowVC.emailTextField.text?.isEmpty)!) {
                    signUpShowVC.emailErrorLabel.isHidden = false
                }
            }

            scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            if (NSStringFromClass(type(of: self)).hasSuffix("ForgotPasswordShowViewController")) {
                scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10 + 25, right: 0)
            } else if (NSStringFromClass(type(of: self)).hasSuffix("SignUpShowViewController")) {
                let signUpShowVC = self as! SignUpShowViewController
                
                scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + ((signUpShowVC.emailTextField.isFirstResponder) ? 10 + 25 : 10), right: 0)
            } else {
                scrollViewBase.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
            }
        }
                
        guard (selectedRange != nil && (keyboardViewEndFrame.contains((selectedRange?.origin)!))) else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.scrollViewBase.contentOffset.y = 0
                }, completion: nil)
            }
            
            return
        }

        scrollViewBase.scrollRectToVisible(selectedRange!, animated: true)
    }
    
    
    // MARK: - Custom Functions
    func setup(topBarView: UIView) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")

        // TopBarView big height
        if (topBarViewStyle == .Big) {
            let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(BaseViewController.handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
        }
        
        // TopBarView small height
        else {
            // Set background color
            self.view.backgroundColor = UIColor.veryDarkDesaturatedBlue24

            // Add Slide Menu actions
            if revealViewController() != nil {
                (topBarView as! SmallTopBarView).actionButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                
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
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
    }
}


// MARK: - UIGestureRecognizerDelegate
extension BaseViewController: UIGestureRecognizerDelegate {
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
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
        } else if (NSStringFromClass(type(of: self)).hasSuffix("SignUpShowViewController")) {
            let signUpShowVC = self as! SignUpShowViewController
            
            if (!signUpShowVC.emailErrorLabel.isHidden) {
                signUpShowVC.emailErrorLabel.isHidden = true
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        (textField as! CustomTextField).attributedPlaceholderString = textField.attributedPlaceholder
        textField.placeholder = nil
        selectedRange = textField.convert(textField.bounds, to: view)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
        textField.attributedPlaceholder = (textField as! CustomTextField).attributedPlaceholderString
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]")
        
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
                    signUpShowVC.emailErrorLabel.isHidden = true
                    signUpShowVC.passwordTextField.becomeFirstResponder()
                } else {
                    signUpShowVC.emailErrorLabel.isHidden = false

                    return false
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
