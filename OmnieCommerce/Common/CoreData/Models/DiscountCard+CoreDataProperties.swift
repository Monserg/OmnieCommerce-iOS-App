//
//  DiscountCard+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension DiscountCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscountCard> {
        return NSFetchRequest<DiscountCard>(entityName: "DiscountCard")
    }

    @NSManaged public var codeID: String
    @NSManaged public var userID: String?
    @NSManaged public var imageID: String?
    @NSManaged public var nameValue: String
    @NSManaged public var code: String
    @NSManaged public var format: String
    @NSManaged public var dateCreated: NSDate
    @NSManaged public var lists: NSSet?

}

// MARK: Generated accessors for lists
extension DiscountCard {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: Lists)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: Lists)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
