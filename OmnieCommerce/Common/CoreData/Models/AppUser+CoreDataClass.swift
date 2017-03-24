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
        self.init(entity: CoreDataManager.instance.entityForName("AppUser"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func dataDidMap(fromDictionary dictionary: [String: Any]) {
        self.firstName      =   dictionary["firstName"] as? String          // Ivan
        self.surName        =   dictionary["surName"] as? String            // Ivanov
        self.gender         =   dictionary["sex"] as! Int16
        self.familyStatus   =   dictionary["familyStatus"] as! Int16
        self.hasChildren    =   dictionary["hasChildren"] as! Int16
        self.hasPet         =   dictionary["hasPet"] as! Int16
        self.birthday       =   (dictionary["birthDay"] as! String).convertToDate(withDateFormat: .ResponseDate) as NSDate?
        self.phone          =   dictionary["userPhone"] as? String
        self.email          =   dictionary["userEmail"] as? String
        
        guard (dictionary["userEmail"] as? String) != nil && (dictionary["image"] as? String) != nil else {
            return
        }
        
        self.imagePath      =   "http://\(dictionary["image"] as! String)"
        self.additionalData =   NSKeyedArchiver.archivedData(withRootObject: dictionary["additionalData"] as! [String: String]) as NSData?
    }
    
    func additionalDataDidMap(fromDictionary dictionary: [String: Any]) {
        self.additionalData =   NSKeyedArchiver.archivedData(withRootObject: dictionary) as NSData?
    }
}
