//
//  TransitionDelegate.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    // MARK: - Class Functions
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionDismissalAnimator()
    }
}
