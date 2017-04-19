//
//  FavoriteOrganizations+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(FavoriteOrganizations)
public class FavoriteOrganizations: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("FavoriteOrganizations")!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
