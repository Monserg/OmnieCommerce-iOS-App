//
//  AppCoordinator.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import SWRevealViewController

class AppCoordinator {
//    // MARK: - Class Initialization
//    init() {
//        // Register to receive notification
//        NotificationCenter.default.addObserver(self, selector: #selector(handlerOfReceivedNotification), name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
//    }
//    
//    
    // MARK: - Class Functions
    func startApp() {
        let window = UIApplication.shared.windows[0]
        let isUserGuest = Config.Constants.isUserGuest
        
        // Initial VC
        if (isUserGuest) {
            let signInShowStoryboard = UIStoryboard(name: "SignInShow", bundle: nil)
            let initialNC = signInShowStoryboard.instantiateViewController(withIdentifier: "SignInShowNC") as! BaseNavigationController
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                window.rootViewController = initialNC
                window.makeKeyAndVisible()
            }
        } else {
            let ordersShowStoryboard = UIStoryboard(name: "SlideMenuShow", bundle: nil)
            let initialVC = ordersShowStoryboard.instantiateViewController(withIdentifier: "RevealVC") as! SWRevealViewController
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                window.rootViewController = initialVC
                window.makeKeyAndVisible()
            }
        }
    }
//    
//    // MARK: - Actions
//    @objc func handlerOfReceivedNotification(notification: Notification) {
//        startApp()
//    }
}
