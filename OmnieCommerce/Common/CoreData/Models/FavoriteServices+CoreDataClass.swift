//
//  FavoriteServices+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(FavoriteServices)
public class FavoriteServices: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("FavoriteServices")!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
