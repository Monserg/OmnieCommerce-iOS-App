//
//  Service+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var nameValue: String?
    @NSManaged public var latitudeValue: Double
    @NSManaged public var longitudeValue: Double
    @NSManaged public var addressCityValue: String?
    @NSManaged public var addressStreetValue: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var rating: Double
    @NSManaged public var logoURL: String?
    @NSManaged public var headerURL: String?
    @NSManaged public var codeID: String
    @NSManaged public var catalog: String?
    @NSManaged public var organizationName: String?
    @NSManaged public var needBackgroundColorSet: Bool
    @NSManaged public var isNameNeedHide: Bool
    @NSManaged public var organization: Organization?
    @NSManaged public var prices: NSSet?
    @NSManaged public var discounts: NSSet?

}

// MARK: Generated accessors for prices
extension Service {

    @objc(addPricesObject:)
    @NSManaged public func addToPrices(_ value: Price)

    @objc(removePricesObject:)
    @NSManaged public func removeFromPrices(_ value: Price)

    @objc(addPrices:)
    @NSManaged public func addToPrices(_ values: NSSet)

    @objc(removePrices:)
    @NSManaged public func removeFromPrices(_ values: NSSet)

}

// MARK: Generated accessors for discounts
extension Service {

    @objc(addDiscountsObject:)
    @NSManaged public func addToDiscounts(_ value: Discount)

    @objc(removeDiscountsObject:)
    @NSManaged public func removeFromDiscounts(_ value: Discount)

    @objc(addDiscounts:)
    @NSManaged public func addToDiscounts(_ values: NSSet)

    @objc(removeDiscounts:)
    @NSManaged public func removeFromDiscounts(_ values: NSSet)

}
