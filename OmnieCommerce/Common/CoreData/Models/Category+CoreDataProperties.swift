//
//  Category+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var codeID: String
    @NSManaged public var imagePath: String?
    @NSManaged public var name: String

}
