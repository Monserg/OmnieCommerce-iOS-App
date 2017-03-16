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
    let body: String?
    var accessToken: String?
    
    
    // MARK: - Class Initialization
    init(fromJSON json: JSON) {
        self.code = json["code"].intValue
        self.status = json["status"].stringValue
        self.body = json["body"].stringValue
        
        if (self.body!.isEmpty) {
            let dictionary = json["body"].dictionary
            CoreDataManager.instance.appUser.didMap(fromDictionary: dictionary!)
        }
    }
}
