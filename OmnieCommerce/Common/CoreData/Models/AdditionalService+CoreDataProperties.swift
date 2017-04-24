//
//  AdditionalService+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension AdditionalService {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdditionalService> {
        return NSFetchRequest<AdditionalService>(entityName: "AdditionalService")
    }

    @NSManaged public var codeID: String
    @NSManaged public var name: String
    @NSManaged public var unit: UInt16
    @NSManaged public var unitName: String
    @NSManaged public var minValue: Int16
    @NSManaged public var maxValue: Int16
    @NSManaged public var price: Double
    @NSManaged public var duration: Int64
    @NSManaged public var service: Service?
    @NSManaged public var discounts: NSSet?

}

// MARK: Generated accessors for discounts
extension AdditionalService {

    @objc(addDiscountsObject:)
    @NSManaged public func addToDiscounts(_ value: Discount)

    @objc(removeDiscountsObject:)
    @NSManaged public func removeFromDiscounts(_ value: Discount)

    @objc(addDiscounts:)
    @NSManaged public func addToDiscounts(_ values: NSSet)

    @objc(removeDiscounts:)
    @NSManaged public func removeFromDiscounts(_ values: NSSet)

}
