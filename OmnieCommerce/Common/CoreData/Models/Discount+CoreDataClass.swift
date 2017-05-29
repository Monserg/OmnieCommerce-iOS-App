//
//  Discount+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Discount)
public class Discount: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "DiscountTableViewCell"
    var cellHeight: CGFloat = 58.0

    
    // MARK: - Class Initialization
    func profileDidUpload(json: [String: AnyObject], isUserDiscount: Bool) {
        // Prepare to save common data
        self.codeID = json["uuid"] as! String
        self.name = json["name"] as! String
        self.percent = json["percent"] as! Int32
        self.status = json["status"] as! Bool
        self.isUserDiscount = isUserDiscount
        self.dateStart = (json["startTerm"] as! String).convertToDate(withDateFormat: .PriceDate) as NSDate
        self.dateEnd = (json["endTerm"] as! String).convertToDate(withDateFormat: .PriceDate) as NSDate
        
        if let organizationID = json["orgUuid"] as? String {
            self.organizationID = organizationID
        }
        
        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
