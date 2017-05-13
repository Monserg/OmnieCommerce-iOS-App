//
//  Category+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var codeID: String
    @NSManaged public var imageID: String?
    @NSManaged public var name: String
    @NSManaged public var categoriesList: Lists?
    @NSManaged public var subCategories: NSSet?
    @NSManaged public var organizations: NSSet?

}

// MARK: Generated accessors for subCategories
extension Category {

    @objc(addSubCategoriesObject:)
    @NSManaged public func addToSubCategories(_ value: Subcategory)

    @objc(removeSubCategoriesObject:)
    @NSManaged public func removeFromSubCategories(_ value: Subcategory)

    @objc(addSubCategories:)
    @NSManaged public func addToSubCategories(_ values: NSSet)

    @objc(removeSubCategories:)
    @NSManaged public func removeFromSubCategories(_ values: NSSet)

}

// MARK: Generated accessors for organizations
extension Category {

    @objc(addOrganizationsObject:)
    @NSManaged public func addToOrganizations(_ value: Organization)

    @objc(removeOrganizationsObject:)
    @NSManaged public func removeFromOrganizations(_ value: Organization)

    @objc(addOrganizations:)
    @NSManaged public func addToOrganizations(_ values: NSSet)

    @objc(removeOrganizations:)
    @NSManaged public func removeFromOrganizations(_ values: NSSet)

}
