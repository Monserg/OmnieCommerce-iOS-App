//
//  Price+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Price)
public class Price: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServicePriceTableViewCell"
    var cellHeight: CGFloat = 44.0

    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forService service: Service) {
        // Prepare to save common data
        self.codeID = json["uuid"] as! String
        self.day = json["day"] as! UInt16
        self.dayName = day.convertToScheduleString()
        self.price = json["price"] as! Double
        self.unit = json["unit"] as! UInt16
        self.unitName = unit.convertToUnitString() ?? "Zorro"
        self.dateCreated = (json["createDate"] as! String).convertToDate(withDateFormat: .PriceDate) as NSDate
        self.ruleTimeStart = json["startRule"] as! String
        self.ruleTimeEnd = json["endRule"] as! String
        
        if let serviceID = json["serviceId"] as? String {
            self.serviceID = serviceID
        }
        
        self.service = service
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
