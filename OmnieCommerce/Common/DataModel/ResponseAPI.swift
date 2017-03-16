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
        self.code = json["code"].intValue
        self.status = json["status"].stringValue
        
        if (json["body"].stringValue.isEmpty) {
            self.body = ""
            let dictionary = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.didMap(fromDictionary: dictionary)
        } else {
            self.body = json["body"].stringValue
        }
    }
}
