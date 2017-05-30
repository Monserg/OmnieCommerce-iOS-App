//
//  BusinessCard+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension BusinessCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessCard> {
        return NSFetchRequest<BusinessCard>(entityName: "BusinessCard")
    }

    @NSManaged public var codeID: String
    @NSManaged public var userID: String?
    @NSManaged public var imageID: String?
    @NSManaged public var nameValue: String
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var phones: [String]?
    @NSManaged public var comment: String?
    @NSManaged public var lists: NSSet?

}

// MARK: Generated accessors for lists
extension BusinessCard {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: Lists)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: Lists)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
