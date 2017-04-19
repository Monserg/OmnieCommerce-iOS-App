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
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String, let subcategoriesList = json["subCategories"] as? [Any] else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let categoryEntity = CoreDataManager.instance.entityForName("Category") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: categoryEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save data
        self.codeID = codeID
        self.name = name
        self.subcategories = NSSet()

        if let imageURL = json["logo"] as? String {
            self.imagePath = "http://\(imageURL)"
        }
        
        for json in subcategoriesList {
            let subcategory = Subcategory.init(json: json as! [String: AnyObject], andType: .Subcategory)
            subcategory!.category = self
            
            self.subcategories!.adding(subcategory!)
        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
