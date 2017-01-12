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
        
        self.rootVC = viewController
    }
}


// MARK: - GIDSignInDelegate
extension SocialGoogle: GIDSignInDelegate {
    public func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            // ...
            print(userId as Any)
            print(idToken as Any)
            print(fullName as Any)
            print(givenName  as Any)
            print(familyName as Any)
            print(email as Any)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user:GIDGoogleUser!, withError error: Error!) {
        print("user disconnected")
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
