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
            scrollView.contentInset = UIEdgeInsets(top: -topBarViewHeight, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 10, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.showsVerticalScrollIndicator = false
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
            self.view.backgroundColor = Config.Views.Colors.veryDarkDesaturatedBlue24

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
