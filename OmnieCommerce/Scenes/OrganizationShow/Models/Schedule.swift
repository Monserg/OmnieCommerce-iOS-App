//
//  Schedule.swift
//  OmnieCommerce
//
//  Created by msm72 on 02.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class Schedule: NSObject, NSCoding, InitCellParameters {
    // MARK: - Properties
    var codeID: String!
    var organizationID: String!
    var day: UInt8!
    var workTimeStart: String!
    var workTimeEnd: String!
    var launchTimeStart: String?
    var launchTimeEnd: String?
    
//    var name: String!
//    var imagePath: String?
//    var subcategories: [Subcategory]!
//    let timeWork: String!
//    let timeLaunch: String!
//    let timeSaturday: String!
//    let timeSunday: String!
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "XXX"
    var cellHeight: CGFloat = 102.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, organizationID: String, day: UInt8!, workTimeStart: String!, workTimeEnd: String!, launchTimeStart: String?, launchTimeEnd: String?) {
        self.codeID = codeID
        self.organizationID = organizationID
        self.day = day
        self.workTimeStart = workTimeStart
        self.workTimeEnd = workTimeEnd
        self.launchTimeStart = launchTimeStart
        self.launchTimeEnd = launchTimeEnd
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let organizationID = aDecoder.decodeObject(forKey: "organizationID") as! String
        let day = aDecoder.decodeObject(forKey: "day") as! UInt8
        let workTimeStart = aDecoder.decodeObject(forKey: "workTimeStart") as! String
        let workTimeEnd = aDecoder.decodeObject(forKey: "workTimeEnd") as! String
        let launchTimeStart = aDecoder.decodeObject(forKey: "launchTimeStart") as? String
        let launchTimeEnd = aDecoder.decodeObject(forKey: "launchTimeEnd") as? String
        
        self.init(codeID: codeID, organizationID: organizationID, day: day, workTimeStart: workTimeStart, workTimeEnd: workTimeEnd, launchTimeStart: launchTimeStart, launchTimeEnd: launchTimeEnd)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(organizationID, forKey: "organizationID")
        aCoder.encode(day, forKey: "day")
        aCoder.encode(workTimeStart, forKey: "workTimeStart")
        aCoder.encode(workTimeEnd, forKey: "workTimeEnd")
        aCoder.encode(launchTimeStart, forKey: "launchTimeStart")
        aCoder.encode(launchTimeEnd, forKey: "launchTimeEnd")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Schedule: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.organizationID = dictionary["orgUuid"] as! String
        self.day = dictionary["day"] as! UInt8
        self.workTimeStart = dictionary["workStart"] as! String
        self.workTimeEnd = dictionary["workEnd"] as! String
        
        if (dictionary["breakStart"] as? String != nil) {
            self.launchTimeStart = dictionary["breakStart"] as? String
        }

        if (dictionary["breakEnd"] as? String != nil) {
            self.launchTimeEnd = dictionary["breakEnd"] as? String
        }
        
        completion()
    }
}


// MARK: - NSCopying
extension Schedule: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Schedule()
        return copy
    }
}
