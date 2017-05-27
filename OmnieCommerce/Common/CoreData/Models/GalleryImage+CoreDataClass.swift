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
    func profileDidUpload(json: [String: AnyObject]) {
        // Prepare to save common data
        if let imageID = json["imageId"] as? String {
            self.codeID = imageID
        }
        
        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }
        
        if let seviceName = json["serviceName"] as? String {
            self.serviceName = seviceName
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
