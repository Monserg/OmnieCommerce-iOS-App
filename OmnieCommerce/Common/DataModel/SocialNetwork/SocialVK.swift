//
//  SocialVK.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import SwiftyVK

typealias LoginComplitionHandler = (Dictionary<String, String>) -> ()
typealias ComplitionHandler = (Bool) -> ()

class SocialVK: VKDelegate {
    // MARK: - Properties
    let appID = "5815487"
    let scope: Set<VK.Scope> = [.messages, .offline, .friends, .wall, .photos, .audio, .video, .docs, .market, .email]
    var loginComplitionHandler: LoginComplitionHandler?
    var rootVC: UIViewController?
    
    
    // MARK: - Class Initialization
    init() {
        print(#function)
        
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    
    // MARK: - Class Functions
    func vkWillPresentView() -> UIViewController {
        rootVC = (UIApplication.shared.delegate!.window!!.rootViewController as! BaseNavigationController).viewControllers.last!
        
        return rootVC!
    }

    func vkWillAuthorize() -> Set<VK.Scope> {
        print(#function)
        
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        print(#function, "parameters = \(parameters)")
        
        guard rootVC != nil else {
            return
        }

        if (VK.state == .authorized && Config.Constants.isUserGuest) {
            // TODO: - SAVE PARAMETERS TO COREDATA
            
            Config.Constants.isUserGuest = false
            
            didTransitionFrom(currentView: rootVC!.view, withCompletionHandler: { (success) in
                (UIApplication.shared.delegate as! AppDelegate).setup()
                AppScenesCoordinator.init().startLaunchScreen()
            })
        }
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print(#function)
        print("Autorization failed with error: \n\(error)")
    }
    
    func vkDidUnauthorize() {
        print(#function)

        // TODO: - SAVE PARAMETERS TO COREDATA
        
        Config.Constants.isUserGuest = true
        (UIApplication.shared.delegate as! AppDelegate).setup()
        AppScenesCoordinator.init().startLaunchScreen()
    }
    
    func vkShouldUseTokenPath() -> String? {
        print(#function)
        
        return nil
    }
    
    
    // MARK: - Custom Functions
    func didTransitionFrom(currentView: UIView, withCompletionHandler completionHandler: @escaping ComplitionHandler) {
        UIView.transition(with: currentView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: {
            currentView.isHidden = true
        }, completion: { _ in
            completionHandler(true)
        })
    }
}
