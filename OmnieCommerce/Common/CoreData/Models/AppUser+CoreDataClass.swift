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
    
    
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("AppUser")!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func dataDidMap(fromDictionary dictionary: [String: Any]) {
        // Set common data
        self.userName = dictionary["userName"] as! String

        // Set additional data
        // Ivan
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        
        // Ivanov
        if let surName = dictionary["surName"] as? String {
            self.surName = surName
        }
        
        if let gender = dictionary["sex"] as? Int16 {
            self.gender = gender
        }

        if let familyStatus = dictionary["familyStatus"] as? Int16 {
            self.familyStatus = familyStatus
        }
        
        if let hasChildren = dictionary["hasChildren"] as? Int16 {
            self.hasChildren = hasChildren
        }
        
        if let hasPet = dictionary["hasPet"] as? Int16 {
            self.hasPet = hasPet
        }
        
        if let birthday = dictionary["birthDay"] as? String {
            self.birthday = birthday.convertToDate(withDateFormat: .ResponseDate) as NSDate?
        }
        
        if let phone = dictionary["userPhone"] as? String {
            self.phone = phone
        }
        
        if let email = dictionary["userEmail"] as? String {
            self.email = email
        }
        
        guard (dictionary["userEmail"] as? String) != nil && (dictionary["image"] as? String) != nil else {
            return
        }
        
        self.imagePath = "http://\(dictionary["image"] as! String)"
        
        guard dictionary["additionalData"] != nil else {
            return
        }
        
        self.additionalData = NSKeyedArchiver.archivedData(withRootObject: dictionary["additionalData"] as! [String: String]) as NSData?
    }
    
    func additionalDataDidMap(fromDictionary dictionary: [String: Any]) {
        self.additionalData = NSKeyedArchiver.archivedData(withRootObject: dictionary) as NSData?
    }
}
