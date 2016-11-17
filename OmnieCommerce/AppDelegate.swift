//
//  AppDelegate.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
//import SWRevealViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {       
        // Check initial scene
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        
//        switch Config.Constants.isUserGuest {
//        // User authorized
//        case false:
//            let ordersShowStoryboard = UIStoryboard(name: "SlideMenuShow", bundle: nil)
//            let initialVC = ordersShowStoryboard.instantiateViewController(withIdentifier: "RevealVC") as! SWRevealViewController
//            self.window?.rootViewController = initialVC
//            
//        // Guest
//        case true:
//            let signInShowStoryboard = UIStoryboard(name: "SignInShow", bundle: nil)
//            let initialNC = signInShowStoryboard.instantiateViewController(withIdentifier: "SignInShowNC") as! BaseNavigationController
//            self.window?.rootViewController = initialNC
//        }
//        
//        self.window?.makeKeyAndVisible()

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
    }


}

