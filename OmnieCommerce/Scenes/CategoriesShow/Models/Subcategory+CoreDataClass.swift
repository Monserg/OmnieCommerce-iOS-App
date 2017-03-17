//
//  Subcategory+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Subcategory)
public class Subcategory: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Subcategory"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }

    
    // MARK: - Custom Functions
    func didMap(fromDictionary dictionary: [String: Any]) {
        self.codeID     =   dictionary["uuid"] as? String
        self.name       =   dictionary["name"] as? String
    }
}
