//
//  Subcategory+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Subcategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subcategory> {
        return NSFetchRequest<Subcategory>(entityName: "Subcategory");
    }

    @NSManaged public var codeID: String?
    @NSManaged public var name: String?

}
