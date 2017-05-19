//
//  AppDelegate.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import GooglePlaces
import GoogleSignIn
import SwiftyVK
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    var previousNetworkReachabilityStatus: Bool = true
    var currentViewController: BaseViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Get stored value
//        CoreDataManager.instance.appSettings = CoreDataManager.instance.entityDidLoad(byName: "AppSettings", andPredicateParameters: nil) as! AppSettings
//        isLightColorAppSchema = CoreDataManager.instance.appSettings.lightColorSchema
        
        // Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Google Maps
        GMSPlacesClient.provideAPIKey("AIzaSyAjgia40VOxC_eaVwrULf1TOjmlw2cwqpE")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        networkDidStopMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Facebook SDK
        FBSDKAppEvents.activateApp()
        networkDidStartMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Facebook SDK
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        networkDidStopMonitoring()
    }
    
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
    
    
    // MARK: - Custom Functions
    func networkDidStartMonitoring() {
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { status in
            var reachableOrNot = ""
            var networkSummary = ""
            
            switch (status) {
            case .reachableViaWWAN, .reachableViaWiFi:
                // Reachable.
                reachableOrNot = "Reachable"
                networkSummary = "Connected to Network"
                
            default:
                // Not reachable.
                reachableOrNot = "Not Reachable"
                networkSummary = "Disconnected from Network"
            }
            
            // Any class which has observer for this notification will be able to report loss of network connection successfully
            if (self.previousNetworkReachabilityStatus != isNetworkAvailable) {
                self.currentViewController?.alertViewDidShow(withTitle: reachableOrNot, andMessage: networkSummary, completion: { _ in })
                self.previousNetworkReachabilityStatus = isNetworkAvailable

//                if (self.currentViewController?.isKind(of: PersonalDataViewController.self))! {
//                    self.currentViewController?.handlerChangeNetworkConnectionStateCompletion!(isNetworkAvailable)
//                }
            }
        }
    }
    
    func networkDidStopMonitoring() {
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
}
