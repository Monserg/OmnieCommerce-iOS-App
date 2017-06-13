//
//  Order+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.06.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var codeID: String
    @NSManaged public var comment: String?
    @NSManaged public var dateSearch: String
    @NSManaged public var dateStart: NSDate
    @NSManaged public var dateEnd: NSDate
    @NSManaged public var discount: Float
    @NSManaged public var imageID: String?
    @NSManaged public var isAvailable: Bool
    @NSManaged public var organizationName: String
    @NSManaged public var price: Float
    @NSManaged public var priceTotal: Float
    @NSManaged public var serviceName: String
    @NSManaged public var status: String
    @NSManaged public var statusHexColor: String
    @NSManaged public var additionalServices: NSSet?
    @NSManaged public var lists: NSSet?

}

// MARK: Generated accessors for additionalServices
extension Order {

    @objc(addAdditionalServicesObject:)
    @NSManaged public func addToAdditionalServices(_ value: AdditionalService)

    @objc(removeAdditionalServicesObject:)
    @NSManaged public func removeFromAdditionalServices(_ value: AdditionalService)

    @objc(addAdditionalServices:)
    @NSManaged public func addToAdditionalServices(_ values: NSSet)

    @objc(removeAdditionalServices:)
    @NSManaged public func removeFromAdditionalServices(_ values: NSSet)

}

// MARK: Generated accessors for lists
extension Order {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: Lists)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: Lists)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
