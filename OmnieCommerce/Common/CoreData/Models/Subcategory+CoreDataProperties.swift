//
//  Subcategory+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Subcategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subcategory> {
        return NSFetchRequest<Subcategory>(entityName: "Subcategory")
    }

    @NSManaged public var codeIDValue: String
    @NSManaged public var nameValue: String
    @NSManaged public var typeValue: String

}
