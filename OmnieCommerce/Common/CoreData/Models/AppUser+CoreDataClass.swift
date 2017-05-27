//
//  AppUser+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

@objc(AppUser)
public class AppUser: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    var cellIdentifier: String = "AppUser"
    var cellHeight: CGFloat = 44.0
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject]) {
        self.codeID = "AppUser"

        // Ivan
        if let firstName = json["firstName"] as? String {
            self.firstName = firstName
        }
        
        // Ivanov
        if let surName = json["surName"] as? String {
            self.surName = surName
        }
        
        if let gender = json["sex"] as? Int16 {
            self.gender = gender
        }
        
        if let familyStatus = json["familyStatus"] as? Int16 {
            self.familyStatus = familyStatus
        }
        
        if let hasChildren = json["hasChildren"] as? Int16 {
            self.hasChildren = hasChildren
        }
        
        if let hasPet = json["hasPet"] as? Int16 {
            self.hasPet = hasPet
        }
        
        if let birthday = json["birthDay"] as? String {
            self.birthday = birthday.convertToDate(withDateFormat: .BirthdayDate) as NSDate
        }
        
        if let imageID = json["userImg"] as? String {
            self.imageID = imageID
        }
        
        if let phone = json["userPhone"] as? String {
            self.phone = phone
        }
        
        if let email = json["userEmail"] as? String {
            self.email = email
        }
        
        if let additionalData = json["additionalData"] as? [String: AnyObject] {
            self.userName = additionalData["userName"] as! String
            self.email = additionalData["userEmail"] as? String
            
            if let registrationDate = (additionalData["registrationDate"] as! String).components(separatedBy: ".").first {
                self.registrationDate = registrationDate.convertToDate(withDateFormat: .RegistrationDate) as NSDate
            }
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
