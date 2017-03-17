//
//  Category+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import CoreData
import SwiftyJSON
import Foundation

@objc(Category)
public class Category: NSManagedObject {
    // MARK: - Class Initialization
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Category"), insertInto: CoreDataManager.instance.managedObjectContext)
    }

    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func didMap(fromDictionary dictionary: [String: Any]) {
        self.codeID                 =   dictionary["uuid"] as? String
        self.name                   =   dictionary["name"] as? String
        self.imagePath              =   dictionary["logo"] as? String
        
        // Map Subcategory list
        let responseSubcategories   =   dictionary["subCategories"] as! NSArray
        var subCategories           =   [Subcategory]()
        
        for dictionary in responseSubcategories {
            let subcategory = Subcategory.init()
            subcategory.didMap(fromDictionary: dictionary as! [String : Any])
            
            subCategories.append(subcategory)
        }
        
        let subcategoriesData       =   NSKeyedArchiver.archivedData(withRootObject: subCategories)
        self.subcategories          =   subcategoriesData as NSData
    }
}
