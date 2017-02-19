//
//  BaseNavigationController.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

class BaseNavigationController: UINavigationController {
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide NavBar
        self.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
