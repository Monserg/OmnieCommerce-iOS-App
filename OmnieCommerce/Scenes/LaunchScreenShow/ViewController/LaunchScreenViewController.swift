//
//  LaunchScreenViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import SWRevealViewController

class LaunchScreenViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet weak var launchScreenView: LaunchScreenView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Config Launch Screen
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Custom Functions
    func setup() {
        AppScenesCoordinator.init().startApp(snapshot: self.view)
    }    
}
