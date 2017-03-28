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
    case UserDataDictionary
    case UserAdditionalDataDictionary
    case CategoriesArray
    case OrganizationsArray
    case OrganizationDictionary
    case FavoriteOrganizationsArray
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
            
        case .OrganizationsArray:
            self.body = json["body"].arrayObject!
            
        case .FavoriteOrganizationsArray:
            self.body = json["body"].arrayObject!
            
        default:
            self.body = json["body"].stringValue
        }
    }
    
    
    // MARK: - Custom Functions
    func organizationsAddressDidLoad(_ organizationsList: [Any], completion: @escaping ((_ organizations: [Organization]) -> ())) {
        var organizations = [Organization]()
        
        for dictionary in organizationsList {
            let organization = Organization.init()
            
            organization.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in
                organizations.append(organization)
                
                if (organizations.count == organizationsList.count) {
                    completion(organizations)
                }
            })
        }
    }
}
