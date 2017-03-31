//
//  Actions+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Actions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Actions> {
        return NSFetchRequest<Actions>(entityName: "Actions")
    }

    @NSManaged public var list: NSData?

}
