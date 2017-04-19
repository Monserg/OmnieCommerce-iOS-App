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
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String else {
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

        if let imageURL = json["logo"] as? String {
            self.imagePath = "http://\(imageURL)"
        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Category: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
//        let codeID = dictionary["uuid"] as! String
//        let name = dictionary["name"] as! String
//        var imagePath: String?
//        
//        if (dictionary["logo"] as? String != nil) {
//            imagePath = "http://\(dictionary["logo"] as! String)"
//        }
        
//        // Create CoreData Entity
//        let categoryEntity = NSManagedObject.init(entity: CoreDataManager.instance.entityForName("Category"), insertInto: CoreDataManager.instance.managedObjectContext) as! Category
//
//        // Map Subcategory list
//        let responseSubcategories = dictionary["subCategories"] as! NSArray
//        var items: [Subcategory]!
//        
//        guard responseSubcategories.count > 0 else {
//            completion()
//            return
//        }
//        
//        for dictionary in responseSubcategories {
//            let subcategory = Subcategory.init(withType: .Subcategory)
//            subcategory.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
//            
//            if (items == nil) {
//                items = [subcategory]
//            } else {
//                items.append(subcategory)
//            }
//        }
//        
//        let subcategories = NSKeyedArchiver.archivedData(withRootObject: items) as NSData
//
//        // Prepare to save in CoreData
//        categoryEntity.codeID = codeID
//        categoryEntity.name = name
//        categoryEntity.imagePath = imagePath
        
        completion()
    }
}
