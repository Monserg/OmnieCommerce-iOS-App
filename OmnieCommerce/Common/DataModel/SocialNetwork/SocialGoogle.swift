//
//  SocialGoogle.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class SocialGoogle: NSObject {
    // MARK: - Properties
    var rootVC: BaseViewController!
    
    
    // MARK: - Class Initialization
    init(withRootViewController viewController: BaseViewController) {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        let message = String(format: "%@ %@", "Google services error".localized(), configureError ?? "")
        assert(configureError == nil, message)
        
        GIDSignIn.sharedInstance().clientID = "1053942437372-g7fke485gbgb84no81rhu8cr6pj3o8gp.apps.googleusercontent.com"

        self.rootVC = viewController
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


// MARK: - GIDSignInDelegate
extension SocialGoogle: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            // TODO: ADD SAVE USER TO COREDATA
            
            // Change App mode
            Config.Constants.isUserGuest = false

            didTransitionFrom(currentView: rootVC!.view, withCompletionHandler: { (success) in
                (UIApplication.shared.delegate as! AppDelegate).setup()
                AppScenesCoordinator.init().startLaunchScreen()
            })

            print("userId = \(userId ?? "is empty")")
            print("idToken = \(idToken ?? "is empty")")
            print("fullName = \(fullName ?? "is empty")")
            print("givenName = \(givenName ?? "is empty")")
            print("familyName = \(familyName ?? "is empty")")
            print("email = \(email ?? "is empty")")
        } else {
            print("\(error.localizedDescription)")
        }
    }
}
