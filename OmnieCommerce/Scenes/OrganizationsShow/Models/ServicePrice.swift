//
//  ServicePrice.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class ServicePrice: NSObject, NSCoding, InitCellParameters {
    // MARK: - Properties
    
    // From common API response
    var codeID: String!
    var day: Int32!
    var price: Double!
    var unit: Int32!
    var serviceID: String!
    var dateCreated: Date!
    var ruleTimeStart: String!
    var ruleTimeEnd: String!
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "XXX"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, day: Int32, price: Double, unit: Int32, serviceID: String, dateCreated: Date, ruleTimeStart: String, ruleTimeEnd: String) {
        self.codeID = codeID
        self.day = day
        self.price = price
        self.unit = unit
        self.serviceID = serviceID
        self.dateCreated = dateCreated
        self.ruleTimeStart = ruleTimeStart
        self.ruleTimeEnd = ruleTimeEnd
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let day = aDecoder.decodeObject(forKey: "day") as! Int32
        let price = aDecoder.decodeObject(forKey: "price") as! Double
        let unit = aDecoder.decodeObject(forKey: "unit") as! Int32
        let serviceID = aDecoder.decodeObject(forKey: "serviceID") as! String
        let dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        let ruleTimeStart = aDecoder.decodeObject(forKey: "ruleTimeStart") as! String
        let ruleTimeEnd = aDecoder.decodeObject(forKey: "ruleTimeEnd") as! String
        
        self.init(codeID: codeID, day: day, price: price, unit: unit, serviceID: serviceID, dateCreated: dateCreated, ruleTimeStart: ruleTimeStart, ruleTimeEnd: ruleTimeEnd)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(day, forKey: "day")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(unit, forKey: "unit")
        aCoder.encode(serviceID, forKey: "serviceID")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(dateCreated, forKey: "ruleTimeStart")
        aCoder.encode(dateCreated, forKey: "ruleTimeEnd")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension ServicePrice: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.day = dictionary["day"] as! Int32
        self.price = dictionary["price"] as! Double
        self.unit = dictionary["unit"] as! Int32
        self.serviceID = dictionary["serviceId"] as! String
        self.dateCreated = (dictionary["createDate"] as! String).convertToDate(withDateFormat: .ResponseDate)
        self.ruleTimeStart = dictionary["startRule"] as! String
        self.ruleTimeEnd = dictionary["endRule"] as! String
        
        completion()
    }
}


// MARK: - NSCopying
extension ServicePrice: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Service()
        return copy
    }
}
