//
//  Service+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var addressCityValue: String?
    @NSManaged public var addressStreetValue: String?
    @NSManaged public var canSendReview: Bool
    @NSManaged public var catalog: String?
    @NSManaged public var categories: [String]?
    @NSManaged public var codeID: String
    @NSManaged public var descriptionContent: String?
    @NSManaged public var duration: Int64
    @NSManaged public var headerURL: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isNameNeedHide: Bool
    @NSManaged public var latitudeValue: Double
    @NSManaged public var logoURL: String?
    @NSManaged public var longitudeValue: Double
    @NSManaged public var minDuration: Bool
    @NSManaged public var nameValue: String?
    @NSManaged public var needBackgroundColorSet: Bool
    @NSManaged public var organizationName: String?
    @NSManaged public var placeID: String?
    @NSManaged public var rating: Double
    @NSManaged public var discounts: NSSet?
    @NSManaged public var images: NSSet?
    @NSManaged public var organization: Organization?
    @NSManaged public var prices: NSSet?
    @NSManaged public var additionalServices: NSSet?

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

// MARK: Generated accessors for additionalServices
extension Service {

    @objc(addAdditionalServicesObject:)
    @NSManaged public func addToAdditionalServices(_ value: AdditionalService)

    @objc(removeAdditionalServicesObject:)
    @NSManaged public func removeFromAdditionalServices(_ value: AdditionalService)

    @objc(addAdditionalServices:)
    @NSManaged public func addToAdditionalServices(_ values: NSSet)

    @objc(removeAdditionalServices:)
    @NSManaged public func removeFromAdditionalServices(_ values: NSSet)

}

// MARK: Generated accessors for images
extension Service {
    
    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: GalleryImage)
    
    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: GalleryImage)
    
    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)
    
    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)
    
}

