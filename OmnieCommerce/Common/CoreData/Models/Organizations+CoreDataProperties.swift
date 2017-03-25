//
//  Organizations+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 25.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Organizations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organizations> {
        return NSFetchRequest<Organizations>(entityName: "Organizations");
    }

    @NSManaged public var list: NSData?

}
