//
//  SignInShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import SWRevealViewController

// MARK: - Input & Output protocols
protocol SignInShowRouterInput {
    func navigateToSomewhere()
}

class SignInShowRouter: SignInShowRouterInput {
    // MARK: - Properties
    weak var viewController: SignInShowViewController!
    var statusCodeNote: StatusCodeNote?
    
    
    // MARK: - Custom Functions. Navigation
    func navigateAuthorizedUser(duringStartApp: Bool) {
        let revealVC                        =   UIStoryboard(name: "SlideMenuShow", bundle: nil).instantiateViewController(withIdentifier: "SWRevealVC") as! SWRevealViewController
        revealVC.modalTransitionStyle       =   (duringStartApp) ? .crossDissolve : .flipHorizontal
        
        // Set Flip Horizontal behaind view background color
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.backgroundColor =   UIColor.veryDarkDesaturatedBlue2f
        
        // Set FrontViewController
        if (duringStartApp) {
            let categoriesNC                =   UIStoryboard(name: "CategoriesShow", bundle: nil).instantiateViewController(withIdentifier: "CategoriesShowNC") as! BaseNavigationController
            
            revealVC.setFront(categoriesNC, animated: true)
        } else {
            var nextNC  =   BaseNavigationController()
            
            if (statusCodeNote == .SUCCESS) {
                nextNC  =   UIStoryboard(name: "CategoriesShow", bundle: nil).instantiateViewController(withIdentifier: "CategoriesShowNC") as! BaseNavigationController
            } else if (statusCodeNote == .CONTINUE) {
                nextNC  =   UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalPageShowNC") as! BaseNavigationController
                (nextNC.viewControllers.first as! PersonalPageShowViewController).userApp       =   CoreDataManager.instance.appUser
            }
            
            revealVC.setFront(nextNC, animated: true)
        }
        
        self.viewController.present(revealVC, animated: true, completion: {
            //        self.viewController.present(revealVC, animated: !duringStartApp, completion: {
            if (duringStartApp) {
                self.navigateBetweenContainerSubviews()
                self.viewController.view.isHidden = false
            }
        })
    }

    func navigateBetweenContainerSubviews() {
        // Apply Container childVC
        viewController.signInContainerShowVC = UIStoryboard(name: "SignInShow", bundle: nil).instantiateViewController(withIdentifier: "SignInContainerShowVC") as? SignInContainerShowViewController
        
        // SignInContainerShowVC: SignIn button handler
        viewController.signInContainerShowVC?.handlerPassDataCompletion = { successCode in
            self.statusCodeNote = StatusCodeNote(rawValue: successCode as! Int)
            
            self.navigateAuthorizedUser(duringStartApp: false)
        }
        
        // Handler: SignInContainerShowVC success Authorization completion
        viewController.signInContainerShowVC?.handlerAuthorizationButtonCompletion = { _ in
            self.viewController.signUpShowVC = UIStoryboard(name: "SignInShow", bundle: nil).instantiateViewController(withIdentifier: "SignUpShowVC") as? SignUpShowViewController
            
            // Handler: SignUpShowVC success Register completion
            self.viewController.signUpShowVC?.handlerRegisterButtonCompletion = { _ in
                self.viewController.signInContainerShowVC?.didCleanTextFields()
                self.viewController.activeViewController = self.viewController.signInContainerShowVC
            }
            
            // Handler: SignUpShowVC success Cancel completion
            self.viewController.signUpShowVC?.handlerCancelButtonCompletion = { _ in
                self.viewController.activeViewController = self.viewController.signInContainerShowVC
            }
            
            self.viewController.activeViewController = self.viewController.signUpShowVC
        }
        
        // Handler: SignInContainerShowVC success ForgotPassword completion
        viewController.signInContainerShowVC?.handlerForgotPasswordButtonCompletion = { _ in
            // Create ForgotPasswordViewController
            self.viewController.forgotPasswordShowVC = UIStoryboard(name: "SignInShow", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordShowVC") as? ForgotPasswordShowViewController
            
            // Handler: ForgotPasswordShowVC success Send completion
            self.viewController.forgotPasswordShowVC?.handlerSendButtonCompletion = { _ in
                // Create EnterCodeShowViewController
                self.viewController.enterCodeShowViewController = UIStoryboard(name: "SignInShow", bundle: nil).instantiateViewController(withIdentifier: "EnterCodeShowVC") as? EnterCodeShowViewController
                
                // Handler: EnterCodeShowVC success Send completion
                self.viewController.enterCodeShowViewController?.handlerSendButtonCompletion = { _ in
                    // Create RepetitionPasswordShow scene
                    self.viewController.repetitionPasswordShowViewController = UIStoryboard(name: "SignInShow", bundle: nil).instantiateViewController(withIdentifier: "RepetitionPasswordShowVC") as? RepetitionPasswordShowViewController
                    
                    // Handler: RepetitionPasswordShowVC success Send completion
                    self.viewController.repetitionPasswordShowViewController?.handlerSendButtonCompletion = { _ in
                        self.viewController.signInContainerShowVC?.didCleanTextFields()
                        self.viewController.activeViewController = self.viewController.signInContainerShowVC
                        
                        // Clean UserDefaults
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    }
                    
                    // Handler: RepetitionPasswordShowVC success Cancel completion
                    self.viewController.repetitionPasswordShowViewController?.handlerCancelButtonCompletion = { _ in
                        self.viewController.activeViewController = self.viewController.enterCodeShowViewController
                    }
                    
                    self.viewController.activeViewController = self.viewController.repetitionPasswordShowViewController
                }
                
                // EnterCodeShowVC: Cancel button handler
                self.viewController.enterCodeShowViewController?.handlerCancelButtonCompletion = { _ in
                    self.viewController.activeViewController = self.viewController.forgotPasswordShowVC
                }
                
                self.viewController.activeViewController = self.viewController.enterCodeShowViewController
            }
            
            // ForgotPasswordShowVC: Cancel button handler
            self.viewController.forgotPasswordShowVC?.handlerCancelButtonCompletion = { _ in
                self.didActiveViewControllerLoad()
            }
            
            self.viewController.activeViewController = self.viewController.forgotPasswordShowVC
            
            // Hide social buttons view
            UIView.animate(withDuration: 0.3) {
                self.viewController.vkontakteButton.isHidden = true
                self.viewController.googleButton.isHidden = true
                self.viewController.facebookButton.isHidden = true
            }
        }
        
        viewController.activeViewController = viewController.signInContainerShowVC
    }
    
    func didActiveViewControllerLoad() {
        self.viewController.signInContainerShowVC?.didCleanTextFields()
        self.viewController.activeViewController = self.viewController.signInContainerShowVC
        
        // Show social buttons view
        UIView.animate(withDuration: 0.3) {
            self.viewController.vkontakteButton.isHidden = false
            self.viewController.googleButton.isHidden = false
            self.viewController.facebookButton.isHidden = false
        }
    }
    
    
    // MARK: - UIContainerView
    func removeInactiveViewController(inactiveViewController: BaseViewController?) {
        if let inactiveVC = inactiveViewController {
            UIView.animate(withDuration: 0.2, animations: {
                inactiveVC.view.transform = CGAffineTransform(translationX: (self.viewController.animationDirection == .FromRightToLeft) ? -1000 : 1000, y: 0)
            }, completion: { success in
                inactiveVC.willMove(toParentViewController: nil)
                inactiveVC.view.removeFromSuperview()
                inactiveVC.removeFromParentViewController()
                
                self.updateActiveViewController()
            })
        }
    }
    
    func updateActiveViewController() {
        if let activeVC = viewController.activeViewController {
            if (self.viewController.animationDirection == nil) {
                addActiveViewController(activeVC)
            } else {
                self.addActiveViewController(activeVC)
                
                UIView.animate(withDuration: 0.2, animations: {
                    activeVC.view.transform = CGAffineTransform(translationX: (self.viewController.animationDirection == .FromRightToLeft) ? -1000 : 0, y: 0)
                })
            }
        }
    }
    
    private func addActiveViewController(_ activeVC: BaseViewController) {
        self.viewController.addChildViewController(activeVC)
        
        if (self.viewController.animationDirection == nil) {
            activeVC.view.frame = self.viewController.containerView.bounds
        } else {
            activeVC.view.frame = CGRect.init(origin: CGPoint.init(x: ((self.viewController.animationDirection == .FromRightToLeft) ? 1000 : -1000), y: 0), size: self.viewController.containerView.bounds.size)
        }
        
        self.viewController.containerView.addSubview(activeVC.view)
        activeVC.didMove(toParentViewController: self.viewController)
    }

    func navigateToSomewhere() {
        // NOTE: Teach the router how to navigate to another scene. Some examples follow:
        // 1. Trigger a storyboard segue
        // viewController.performSegueWithIdentifier("ShowSomewhereScene", sender: nil)
        
        // 2. Present another view controller programmatically
        // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)
        
        // 3. Ask the navigation controller to push another view controller onto the stack
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
        
        // 4. Present a view controller from a different storyboard
        // let storyboard = UIStoryboard(name: "OtherThanMain", bundle: nil)
        // let someWhereViewController = storyboard.instantiateInitialViewController() as! SomeWhereViewController
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    }
    
    // Communication
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue: segue)
        }
    }
    
    // Transition
    func passDataToSomewhereScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene
        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.output.name = viewController.output.name
    }
}
