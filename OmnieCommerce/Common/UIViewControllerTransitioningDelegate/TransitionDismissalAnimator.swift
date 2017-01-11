//
//  TransitionDismissalAnimator.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Class Functions
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self.transitionDuration(using: transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)!
        snapshotView.center = toViewController.view.center
        containerView.addSubview(snapshotView)
        
        fromViewController.view.alpha = 0.0
        
        let toViewControllerSnapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)!
        containerView.insertSubview(toViewControllerSnapshotView, belowSubview: snapshotView)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            snapshotView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            snapshotView.alpha = 0.0
        }) { (finished) -> Void in
            toViewControllerSnapshotView.removeFromSuperview()
            snapshotView.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
