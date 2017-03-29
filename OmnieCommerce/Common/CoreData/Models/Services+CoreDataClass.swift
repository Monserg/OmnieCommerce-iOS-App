//
//  Services+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Services)
public class Services: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Services"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
