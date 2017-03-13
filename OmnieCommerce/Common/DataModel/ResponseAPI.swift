//
//  ResponseAPI.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResponseAPI {
    // MARK: - Properties
    let code: Int!
    let status: String!
    let body: String!
    
    
    // MARK: - Class Initialization
    init(fromJSON json: JSON) {
        self.code       =   json["code"].intValue
        self.status     =   json["status"].stringValue
        self.body       =   json["body"].stringValue
    }
    
//    init(code: NSNumber, status: String, body: String) {
//        self.code       =   code
//        self.status     =   status
//        self.body       =   body
//    }
//    
//    required init?(map: Map) {}
//    
//    
//    // MARK: - Class Functions
//    func mapping(map: Map) {
//        self.code       <-  map["code"]
//        self.status     <-  map["status"]
//        self.body       <-  map["body"]
//    }
}
