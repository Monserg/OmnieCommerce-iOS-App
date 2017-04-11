//
//  GalleryImage.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class GalleryImage: NSObject, NSCoding, InitCellParameters {
    // MARK: - Properties
    var imageID: String!
    var imagePath: String!
    var serviceID: String?
    var serviceName: String?
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "CirclePhotoCollectionViewCell"
    var cellHeight: CGFloat = 102.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(imageID: String, imagePath: String, serviceID: String?, serviceName: String?) {
        self.imageID = imageID
        self.imagePath = imagePath
        self.serviceID = serviceID
        self.serviceName = serviceName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let imageID = aDecoder.decodeObject(forKey: "imageID") as! String
        let imagePath = aDecoder.decodeObject(forKey: "imagePath") as! String
        let serviceID = aDecoder.decodeObject(forKey: "serviceID") as? String
        let serviceName = aDecoder.decodeObject(forKey: "serviceName") as? String
        
        self.init(imageID: imageID, imagePath: imagePath, serviceID: serviceID, serviceName: serviceName)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(imageID, forKey: "imageID")
        aCoder.encode(imagePath, forKey: "imagePath")
        aCoder.encode(serviceID, forKey: "serviceID")
        aCoder.encode(serviceName, forKey: "serviceName")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension GalleryImage: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.imageID = dictionary["imageId"] as! String
        
        if (dictionary["staticUrl"] as? String != nil) {
            self.imagePath = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["staticUrl"] as! String)"
        }
        
        if (dictionary["serviceId"] as? String != nil) {
            self.serviceID = dictionary["serviceId"] as? String
        }
        
        if (dictionary["serviceName"] as? String != nil) {
            self.serviceName = dictionary["serviceName"] as? String
        }
        
        completion()
    }
}


// MARK: - NSCopying
extension GalleryImage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GalleryImage()
        return copy
    }
}
