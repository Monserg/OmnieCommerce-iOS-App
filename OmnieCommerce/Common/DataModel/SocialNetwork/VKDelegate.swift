//
//  VKDelegate.swift
//  OmnieCommerce
//
//  Created by msm72 on 10.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyVK

class VKDelegate: VKDelegate {
    // MARK: - Properties
    let appID = "5815487"
    let scope: Set<VK.Scope> = [.messages, .offline, .friends, .wall, .photos, .audio, .video, .docs, .market, .email]
    
    
    // MARK: - Class Initialization
    init() {
        print(#function)
        
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    
    // MARK: - Class Functions
    func vkWillAuthorize() -> Set<VK.Scope> {
        print(#function)
        
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        print(#function)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print(#function)
        print("Autorization failed with error: \n\(error)")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    func vkDidUnauthorize() {
        print(#function)
    }
    
    func vkShouldUseTokenPath() -> String? {
        print(#function)
        
        return nil
    }
}
