//
//  SocialNetworkManager.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 16.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyVK
import Google
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

enum NetworkType: Int {
    case VK         =   0
    case Google     =   1
    case Facebook   =   2
}

class SocialNetworkManager: UIViewController {
    // MARK: - Properties
    let vkAppID = "5815487"
    let vkScope: Set<VK.Scope> = [.messages, .offline, .friends, .wall, .photos, .audio, .video, .docs, .market, .email]
    
    let googleID = "1053942437372-g7fke485gbgb84no81rhu8cr6pj3o8gp.apps.googleusercontent.com"
    
    var configureError: NSError?
    var networkType: NetworkType!
    
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }

    
    // MARK: - Custom Functions
    init(withNetwork rawValue: NetworkType.RawValue) {
        super.init(nibName: nil, bundle: nil)
        
        self.networkType = NetworkType.init(rawValue: rawValue)
        
        switch networkType! {
        case .VK:
            VK.config.logToConsole = true
            VK.configure(withAppId: vkAppID, delegate: self)

        case .Google:
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")

            GIDSignIn.sharedInstance().clientID = googleID
            GIDSignIn.sharedInstance().delegate = self

        case .Facebook: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // VK
    func didAuthorizeUser() {
        switch networkType! {
        case .VK:
            VK.logOut()
            VK.logIn()

        case .Google:
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().signIn()

        default:
            break
        }
    }
    
    func didLogoutUser() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
    func Validation() {
        VK.API.custom(method: "account.testValidation").send(
            onSuccess: { response in print("SwiftyVK: account.testValidation success \n \(response)") },
            onError: { error in print("SwiftyVK: account.testValidation fail \n \(error)") }
        )
    }
    
    func didLoadUsers() {
        VK.API.Users.get([VK.Arg.userId : "1"]).send(
            onSuccess: { response in print("SwiftyVK: users.get success \n \(response)") },
            onError: { error in print("SwiftyVK: users.get fail \n \(error)") }
        )
    }
}


// MARK: - VKDelegate
extension SocialNetworkManager: VKDelegate {
    // Called when SwiftyVK need authorization permissions
    func vkWillAuthorize() -> Set<VK.Scope> {
        return vkScope
    }
    
    // Called when the user is log in
    // Here you can start to send requests to the API
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        guard handlerSendButtonCompletion != nil else {
            return
        }
        
        handlerSendButtonCompletion!()
    }
    
    // Called when user is log out
    func vkDidUnauthorize() {}

    // Called when SwiftyVK could not authorize. To let the application know that something went wrong
    func vkAutorizationFailedWith(error: AuthError) {}

    // Called when SwiftyVK need know where a token is located
    func vkShouldUseTokenPath() -> String? {
        return nil
    }

    // Only for iOS! Called when need to display a view from SwiftyVK
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}


// MARK: - Google SDK
extension SocialNetworkManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(userId ?? "xxx")
            print(idToken ?? "xxx")
            print(fullName ?? "xxx")
            print(familyName ?? "xxx")
            print(givenName ?? "xxx")
            print(email ?? "xxx")
            
            CoreDataManager.instance.didUpdateAppUser(state: true)

            handlerSendButtonCompletion!()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
}
