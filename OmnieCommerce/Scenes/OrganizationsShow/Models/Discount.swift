//
//  Discount.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class Discount: NSObject, NSCoding, InitCellParameters {
    // MARK: - Properties
    var codeID: String!
    var name: String!
    var organizationID: String!
    var percent: Int32!
    var status: Bool!
    var dateStart: Date!
    var dateEnd: Date!
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "XXX"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, name: String, organizationID: String, percent: Int32, status: Bool, dateStart: Date, dateEnd: Date) {
        self.codeID = codeID
        self.name = name
        self.organizationID = organizationID
        self.percent = percent
        self.status = status
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let organizationID = aDecoder.decodeObject(forKey: "organizationID") as! String
        let percent = aDecoder.decodeObject(forKey: "percent") as! Int32
        let status = aDecoder.decodeObject(forKey: "status") as! Bool
        let dateStart = aDecoder.decodeObject(forKey: "dateStart") as! Date
        let dateEnd = aDecoder.decodeObject(forKey: "dateEnd") as! Date
        
        self.init(codeID: codeID, name: name, organizationID: organizationID, percent: percent, status: status, dateStart: dateStart, dateEnd: dateEnd)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(organizationID, forKey: "organizationID")
        aCoder.encode(percent, forKey: "percent")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(dateStart, forKey: "dateStart")
        aCoder.encode(dateEnd, forKey: "dateEnd")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Discount: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.name = dictionary["name"] as! String
        self.organizationID = dictionary["orgUuid"] as! String
        self.percent = dictionary["percent"] as! Int32
        self.status = dictionary["status"] as! Bool
        self.dateStart = (dictionary["startTerm"] as! String).convertToDate(withDateFormat: .ResponseDate)
        self.dateEnd = (dictionary["endTerm"] as! String).convertToDate(withDateFormat: .ResponseDate)
        
        completion()
    }
}


// MARK: - NSCopying
extension Discount: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Discount()
        return copy
    }
}
