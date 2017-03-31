//
//  Actions+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Actions)
public class Actions: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Actions"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
