//
//  Subcategory+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Subcategory)
public class Subcategory: NSManagedObject, InitCellParameters, DropDownItem {
    // MARK: - Properties
    // Confirm DropDownItem protocol
    var codeID: String! {
        set {
            self.codeIDValue = newValue
        }
        
        get {
            return self.codeIDValue
        }
    }
    
    var name: String! {
        set {
            self.nameValue = newValue
        }
        
        get {
            return self.nameValue
        }
    }
    
    var type: DropDownItemType! {
        get {
            return DropDownItemType(rawValue: self.typeValue)
        }
        
        set {
            self.typeValue = newValue.rawValue
        }
    }

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "DropDownTableViewCell"
    var cellHeight: CGFloat = Config.Constants.dropDownCellHeight

    
    // MARK: - Class Initialization
    convenience init(codeID: String, name: String, type: DropDownItemType, category: Category) {
        // Create Entity
        self.init(entity: CoreDataManager.instance.entityForName("Subcategory")!, insertInto: CoreDataManager.instance.managedObjectContext)
        
        self.codeID = codeID
        self.name = name
        self.type = type
        self.category = category
    }
    
    convenience init?(json: [String: AnyObject], category: Category, andType type: DropDownItemType) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let subCategoryEntity = CoreDataManager.instance.entityForName("Subcategory") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: subCategoryEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.type = type
        self.category = category
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
