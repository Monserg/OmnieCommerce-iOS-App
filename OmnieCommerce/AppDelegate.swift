//
//  AppDelegate.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import SwiftyVK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    var socialVKDelegate: VKDelegate?

    
    // MARK: - Class Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Facebook initialize
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Google initialize
        GIDSignIn.sharedInstance().clientID = "1053942437372-g7fke485gbgb84no81rhu8cr6pj3o8gp.apps.googleusercontent.com"

        // VK initialize sign-in
        socialVKDelegate = SocialVK()

        // Initialization
        setup()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    
    // MARK: - Custom Functions
    func setup() {
        window?.backgroundColor = UIColor.veryDarkDesaturatedBlue25Alpha94
        let lanchScreenView = LaunchScreenView.init(frame: window!.frame)
        window?.addSubview(lanchScreenView.view)
    }
    
    func changeBackgroundView() {
        let isUserGuest = Config.Constants.isUserGuest
        
        _ = window?.subviews.map{ $0.isHidden = (isUserGuest) ? false : true }
    }
    
    
    // MARK: - VKDelegate
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.absoluteString.hasPrefix("vk")) {
            let app = options[.sourceApplication] as? String
            VK.process(url: url, sourceApplication: app)
            
            return true
        } else if (url.absoluteString.contains("com.googleusercontent.apps")) {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }
}
