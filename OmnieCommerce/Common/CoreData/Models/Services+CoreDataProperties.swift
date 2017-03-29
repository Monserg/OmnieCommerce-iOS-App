//
//  Services+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Services {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Services> {
        return NSFetchRequest<Services>(entityName: "Services")
    }

    @NSManaged public var list: NSData?

}
