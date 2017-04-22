//
//  Organization+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var addressCityValue: String?
    @NSManaged public var addressStreetValue: String?
    @NSManaged public var canSendReview: Bool
    @NSManaged public var catalog: String?
    @NSManaged public var codeID: String
    @NSManaged public var descriptionContent: String?
    @NSManaged public var descriptionTitle: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var latitudeValue: Double
    @NSManaged public var logoURL: String?
    @NSManaged public var longitudeValue: Double
    @NSManaged public var nameValue: String?
    @NSManaged public var phones: [String]?
    @NSManaged public var placeID: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviews: [Review]?
    @NSManaged public var email: String?
    @NSManaged public var headerURL: String?
    @NSManaged public var category: NSSet?
    @NSManaged public var discounts: NSSet?
    @NSManaged public var schedules: NSSet?
    @NSManaged public var images: NSSet?
    @NSManaged public var services: NSSet?

}

// MARK: Generated accessors for category
extension Organization {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: Category)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: Category)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

// MARK: Generated accessors for discounts
extension Organization {

    @objc(addDiscountsObject:)
    @NSManaged public func addToDiscounts(_ value: Discount)

    @objc(removeDiscountsObject:)
    @NSManaged public func removeFromDiscounts(_ value: Discount)

    @objc(addDiscounts:)
    @NSManaged public func addToDiscounts(_ values: NSSet)

    @objc(removeDiscounts:)
    @NSManaged public func removeFromDiscounts(_ values: NSSet)

}

// MARK: Generated accessors for schedules
extension Organization {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: Schedule)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: Schedule)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

// MARK: Generated accessors for images
extension Organization {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: GalleryImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: GalleryImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for services
extension Organization {

    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)

    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)

    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)

    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)

}
