//
//  Order+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "OrderTableViewCell"
    var cellHeight: CGFloat = 96.0


    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forList listName: String) {
        // Prepare to save common data
        self.codeID = json["uuid"] as! String
        self.organizationName = json["orgName"] as! String
        self.serviceName = json["serviceName"] as! String
        self.dateStart = (json["start"] as! String).convertToDate(withDateFormat: .Default) as NSDate
        self.priceTotal = json["totalPrice"] as! Float
        self.status = json["status"] as! String
        self.statusHexColor = self.status.convertToHexColor()

        if let imageID = json["imageId"] as? String {
            self.imageID = imageID
        }
        

        // Prepare to save additional data
        if let dateEnd = json["end"] as? String {
            self.dateEnd = dateEnd
        }
        
        if let discount = json["discount"] as? Float {
            self.discount = discount
        }
        
        if let price = json["price"] as? Float {
            self.price = price
        }
        
        self.addToLists(Lists.init(name: listName, item: self))
    }
}
