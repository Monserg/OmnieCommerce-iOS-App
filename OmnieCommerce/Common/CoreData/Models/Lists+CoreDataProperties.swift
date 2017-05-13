//
//  Lists+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Lists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lists> {
        return NSFetchRequest<Lists>(entityName: "Lists")
    }

    @NSManaged public var name: String?
    @NSManaged public var news: NSSet?
    @NSManaged public var categories: NSSet?

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
