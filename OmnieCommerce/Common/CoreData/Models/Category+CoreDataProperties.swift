//
//  Category+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.04.17.
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
    @NSManaged public var subcategories: NSSet?

}

// MARK: Generated accessors for subcategories
extension Category {

    @objc(addSubcategoriesObject:)
    @NSManaged public func addToSubcategories(_ value: Subcategory)

    @objc(removeSubcategoriesObject:)
    @NSManaged public func removeFromSubcategories(_ value: Subcategory)

    @objc(addSubcategories:)
    @NSManaged public func addToSubcategories(_ values: NSSet)

    @objc(removeSubcategories:)
    @NSManaged public func removeFromSubcategories(_ values: NSSet)

}
