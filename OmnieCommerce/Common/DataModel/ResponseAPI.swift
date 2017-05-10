//
//  ResponseAPI.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

enum BodyType {
    case Default
    case ItemsArray
    case ItemsDictionary
    
    case ServicesArray
    case UserDataDictionary
    case UserAdditionalDataDictionary
    case CategoriesArray
    case OrganizationsArray
    case OrganizationDictionary
}

public enum StatusCodeNote: Int {
    case SUCCESS                    =   200     //  GET or DELETE result is successful
    case CONTINUE                   =   2201    //  POST result is successful & need continue
    case CREATED                    =   201     //  POST or PUT is successful
    case NOT_MODIFIED               =   304     //  If caching is enabled and etag matches with the server
    case SOMETHING_WRONG_3894       =   3894
    case BAD_REQUEST                =   400     //  Possibly the parameters are invalid
    case INVALID_CREDENTIAL         =   401     //  INVALID CREDENTIAL, possible invalid token
    case NOT_FOUND                  =   404     //  The item you looked for is not found
    case CONFLICT                   =   409     //  Conflict - means already exist
    case AUTHENTICATION_EXPIRED     =   419     //  Expired
    case WRONG_SHOW_INFO            =   4200    //  Failed on showing info
    case BAD_AUTHORIZATION          =   4401    //  BAD AUTHORIZATION
    case INCORRECT_PASSWORD         =   4402    //  PASSWORD IS INCORRECT
    case WRONG_INPUT_DATA           =   4500    //  WRONG INPUT DATA
    case USER_EXIST                 =   4670

    var name: String {
        get { return String(describing: self) }
    }
}

class ResponseAPI {
    // MARK: - Properties
    var code: Int!
    var status: String!
    var body: Any?
    
    
    // MARK: - Class Initialization
    init(withError error: Error) {
        self.code = 999
        self.status = error.localizedDescription
    }
    
    init(fromJSON json: JSON, withBodyType type: BodyType) {
        self.code = json["code"].intValue
        self.status = StatusCodeNote.init(rawValue: self.code)!.name
        
        switch type {
        case .UserDataDictionary:
            self.body = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.dataDidMap(fromDictionary: self.body as! [String: Any])

        case .UserAdditionalDataDictionary:
            self.body = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.additionalDataDidMap(fromDictionary: self.body as! [String: Any])

        case .ItemsDictionary:
            self.body = json["body"].dictionaryObject!
            
        case .ItemsArray:
            self.body = json["body"].arrayObject
            
        case .OrganizationsArray:
            self.body = json["body"].arrayObject!

        default:
            self.body = json["body"].stringValue
        }
    }
    
    
    // MARK: - Custom Functions
    func itemsDidLoad<T: NSObject>(fromItemsArray itemsList: [Any], withItem item: T, completion: @escaping ((_ items: [T]) -> ())) {
        var items = [T]()
        
        if (itemsList.count > 0) {
            for dictionary in itemsList {
                let itemValue = item.copy()
                
                (itemValue as! MapObjectBinding).didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in
                    items.append(itemValue as! T)
                    
                    if (items.count == itemsList.count) {
                        completion(items)
                    }
                })
            }
        } else {
            completion(items)
        }
    }
}
