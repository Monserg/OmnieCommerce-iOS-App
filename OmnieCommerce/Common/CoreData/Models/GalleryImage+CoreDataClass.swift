//
//  GalleryImage+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(GalleryImage)
public class GalleryImage: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "CirclePhotoCollectionViewCell"
    var cellHeight: CGFloat = 102.0

    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], andRelationshipObject managedObject: NSManagedObject?) {
        guard let imageID = json["imageId"] as? String, let imagePath = json["staticUrl"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let galleryImageEntity = CoreDataManager.instance.entityForName("GalleryImage") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: galleryImageEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.imageID = imageID
        
        if (imagePath.contains("/images/")) {
            self.imagePath = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(imagePath)"
        }
        
        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }
        
        if let seviceName = json["serviceName"] as? String {
            self.serviceName = seviceName
        }
        
        if let organization = managedObject as? Organization {
            self.organization = organization
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
