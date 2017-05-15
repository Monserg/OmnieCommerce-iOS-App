//
//  Category+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "CategoryCollectionViewCell"
    var cellHeight: CGFloat = 102.0

    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject]) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String, let subCategoriesList = json["subCategories"] as? [Any] else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let categoryEntity = CoreDataManager.instance.entityForName("Category") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: categoryEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name

        if let imageID = json["logo"] as? String {
            self.imageID = imageID
        }
        
        // Create SubCategories
        if (subCategoriesList.count > 0) {
            for json in subCategoriesList {
                let subCategory = Subcategory.init(json: json as! [String: AnyObject], category: self, andType: .Subcategory, managedObject: nil)
                self.addToSubCategories(subCategory!)
            }
        }
        
        // Add to Categories list
        self.categoriesList = Lists.init(name: keyCategories, item: self)
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
