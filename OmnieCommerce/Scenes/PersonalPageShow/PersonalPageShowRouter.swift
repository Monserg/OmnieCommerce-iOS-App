//
//  PersonalPageShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol PersonalPageShowRouterInput {
    func navigateToSomewhere()
}

class PersonalPageShowRouter: PersonalPageShowRouterInput {
    // MARK: - Properties
    weak var viewController: PersonalPageShowViewController!
    
    
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
                    activeVC.view.transform     =   CGAffineTransform(translationX: (self.viewController.animationDirection == .FromRightToLeft) ? 0 : 0, y: 0)
                })
            }
        }
    }

    private func addActiveViewController(_ activeVC: BaseViewController) {
        self.viewController.addChildViewController(activeVC)
        
        if (self.viewController.animationDirection == nil) {
            activeVC.view.frame         =   self.viewController.containerView.bounds
        } else {
            activeVC.view.frame.size    =   self.viewController.containerView.frame.size
            activeVC.view.transform     =   CGAffineTransform(translationX: (self.viewController.animationDirection == .FromRightToLeft) ? 1000 : -1000, y: 0)
        }
        
        self.viewController.containerView.addSubview(activeVC.view)
        activeVC.didMove(toParentViewController: self.viewController)
    }

    
    // MARK: - Custom Functions. Navigation
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
