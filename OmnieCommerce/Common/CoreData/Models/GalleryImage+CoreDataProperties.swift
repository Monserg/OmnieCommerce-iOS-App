//
//  GalleryImage+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 27.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension GalleryImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryImage> {
        return NSFetchRequest<GalleryImage>(entityName: "GalleryImage")
    }

    @NSManaged public var codeID: String
    @NSManaged public var serviceID: String?
    @NSManaged public var serviceName: String?
    @NSManaged public var organization: Organization?
    @NSManaged public var service: Service?

}
