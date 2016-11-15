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
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func setup(withTitle title: String) {
        // Add Slide Menu actions
        if revealViewController() != nil {
            
//            topBarView.menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rightViewRevealWidth = 296
            revealViewController().frontViewShadowColor = UIColor.white
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
