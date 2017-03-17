//
//  ResponseAPI.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON

enum BodyType {
    case Default
    case ServicesArray
    case UserDictionary
    case CategoriesArray
    case OrganizationsArray
    case OrganizationDictionary
}

class ResponseAPI {
    // MARK: - Properties
    var code: Int?
    var status: String?
    var body: Any?
    var errorMessage: String?
        
    
    // MARK: - Class Initialization
    init(withErrorMessage type: BodyType) {
        switch type {
        case .UserDictionary:
            self.errorMessage = "4401 - Bad Authorization".localized()
            
        default:
            self.errorMessage = "404 - Wrong Found".localized()
        }
    }
    
    init(fromJSON json: JSON, withBodyType type: BodyType) {
        self.code = json["code"].intValue
        self.status = json["status"].stringValue
        
        switch type {
        case .UserDictionary:
            self.body = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.didMap(fromDictionary: self.body as! [String: Any])
        
        default:
            self.body = json["body"].stringValue
        }
    }
}
