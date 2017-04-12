//
//  GalleryImage+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension GalleryImage1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryImage1> {
        return NSFetchRequest<GalleryImage1>(entityName: "GalleryImage1")
    }

    @NSManaged public var imageID: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var serviceID: String?
    @NSManaged public var serviceName: String?

}
