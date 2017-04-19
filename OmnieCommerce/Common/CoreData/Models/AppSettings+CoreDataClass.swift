//
//  AppSettings+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(AppSettings)
public class AppSettings: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("AppSettings")!, insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
