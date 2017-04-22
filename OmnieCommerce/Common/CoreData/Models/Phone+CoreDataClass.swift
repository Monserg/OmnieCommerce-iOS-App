//
//  Phone+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Phone)
public class Phone: NSManagedObject {
    // MARK: - Class Initialization
    convenience init?(string: String) {
        // Check Entity available in CoreData
        guard let phoneEntity = CoreDataManager.instance.entityForName("Phone") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: phoneEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.number = string

        CoreDataManager.instance.didSaveContext()
    }
}
