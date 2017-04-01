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
    case ItemsArray
    case ItemsDictionary
    
    case ServicesArray
    case UserDataDictionary
    case UserAdditionalDataDictionary
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
        case .UserDataDictionary:
            self.errorMessage = "4401 - Bad Authorization".localized()
            
        default:
            self.errorMessage = "404 - Wrong Found".localized()
        }
    }
    
    init(fromJSON json: JSON, withBodyType type: BodyType) {
        self.code = json["code"].intValue
        self.status = json["status"].stringValue
        
        switch type {
        case .UserDataDictionary:
            self.body = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.dataDidMap(fromDictionary: self.body as! [String: Any])

        case .UserAdditionalDataDictionary:
            self.body = json["body"].dictionaryObject!
            CoreDataManager.instance.appUser.additionalDataDidMap(fromDictionary: self.body as! [String: Any])

        case .CategoriesArray:
            let responseCategories = json["body"].arrayObject!
            var categories = [Category]()
            
            for dictionary in responseCategories {
                let category = Category.init()
                category.didMap(fromDictionary: dictionary as! [String : Any])
                
                categories.append(category)
            }
            
            self.body = categories
            
        case .ItemsArray:
            self.body = json["body"].arrayObject!
            
        case .OrganizationsArray:
            self.body = json["body"].arrayObject!

        default:
            self.body = json["body"].stringValue
        }
    }
    
    
    // MARK: - Custom Functions
    func itemsDidLoad<T: NSObject>(fromItemsArray itemsList: [Any], withItem item: T, completion: @escaping ((_ items: [T]) -> ())) {
        var items = [T]()
        
        for dictionary in itemsList {
            let itemValue = item
            
            (itemValue as! MapObjectBinding).didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in
                items.append(itemValue)
                
                if (items.count == itemsList.count) {
                    completion(items)
                }
            })
        }
    }
}
