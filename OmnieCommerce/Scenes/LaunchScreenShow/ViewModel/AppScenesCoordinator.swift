//
//  AppScenesCoordinator.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import SWRevealViewController

class AppScenesCoordinator {
    // MARK: - Class Functions
    func startLaunchScreen() {
        let window = (UIApplication.shared.windows.count == 0) ? UIWindow(frame: UIScreen.main.bounds) : UIApplication.shared.windows[0]
        let storyboardName = UIStoryboard(name: "Main", bundle: nil)
        let launchScreenVC = storyboardName.instantiateViewController(withIdentifier: "LaunchScreenVC") as! LaunchScreenViewController
        
        window.rootViewController = launchScreenVC
        window.makeKeyAndVisible()
    }
    
    func startApp(snapshot: UIView) {
        let window = UIApplication.shared.windows[0]
        let isUserGuest = Config.Constants.isUserGuest
        let initialVC: UIViewController!
        let storyboardName: UIStoryboard!
        
        // Initial VC
        if (isUserGuest) {
            storyboardName = UIStoryboard(name: "SignInShow", bundle: nil)
            initialVC = storyboardName.instantiateViewController(withIdentifier: "SignInShowNC") as! BaseNavigationController
        } else {
            storyboardName = UIStoryboard(name: "SlideMenuShow", bundle: nil)
            initialVC = storyboardName.instantiateViewController(withIdentifier: "RevealVC") as! SWRevealViewController
        }
        
        initialVC.view.addSubview(snapshot)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.9) {
            window.rootViewController = initialVC
            
            UIView.animate(withDuration: 1.3, animations: { _ in
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
}
