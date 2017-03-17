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
    func didMap(fromDictionary dictionary: [String: Any]) {
        self.firstName = dictionary["firstName"] as? String         // Ivan
        self.lastName = dictionary["lastName"] as? String           // Ivanov
        self.surName = dictionary["surName"] as? String             // Ivanovich
        self.gender = dictionary["sex"] as! Int16
        self.familyStatus = dictionary["familyStatus"] as! Int16
        self.hasChildren = dictionary["hasChildren"] as! Int16
        self.hasPet = dictionary["hasPet"] as! Int16
        
        
        //        self.birthday =
        
        
//        "birthDay": "Nov 11, 2011 12:00:00 AM",


    }
}
