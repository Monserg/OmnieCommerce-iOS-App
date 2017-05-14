//
//  Lists+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 14.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Lists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lists> {
        return NSFetchRequest<Lists>(entityName: "Lists")
    }

    @NSManaged public var name: String
    @NSManaged public var categories: NSSet?
    @NSManaged public var news: NSSet?
    @NSManaged public var organizations: NSSet?

}

// MARK: Generated accessors for categories
extension Lists {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for news
extension Lists {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: NewsData)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: NewsData)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)

}

// MARK: Generated accessors for organizations
extension Lists {

    @objc(addOrganizationsObject:)
    @NSManaged public func addToOrganizations(_ value: Organization)

    @objc(removeOrganizationsObject:)
    @NSManaged public func removeFromOrganizations(_ value: Organization)

    @objc(addOrganizations:)
    @NSManaged public func addToOrganizations(_ values: NSSet)

    @objc(removeOrganizations:)
    @NSManaged public func removeFromOrganizations(_ values: NSSet)

}
