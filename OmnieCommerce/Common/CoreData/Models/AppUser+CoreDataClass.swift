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
//        self.birthday =
        self.firstName = dictionary["firstName"] as? String
        self.gender = dictionary["sex"] as! Int16
//        self.lastName =
    }
}
