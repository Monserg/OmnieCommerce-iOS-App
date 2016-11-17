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
    var topBarViewRounding = CircleView.CirleRadius.small
//    let onmieSoftCopyright = "\u{00A9} Omniesoft, 2016"
    
        
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func setup(topBarView: TopBarView) {
        // Set background color
        self.view.backgroundColor = Config.Views.Colors.veryDarkDesaturatedBlue24
        
        // .small radius
        if (topBarViewRounding == .small) {
            print(".small")
        }
        
        // .big radius
        else {
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
    }
}
