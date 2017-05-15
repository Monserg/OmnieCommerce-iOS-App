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
        
        // Prepare to save common data
        self.codeID = codeID
        self.name = name
        self.type = type
        self.category = category
    }
    
    convenience init?(json: [String: AnyObject], category: Category, andType type: DropDownItemType, managedObject: NSManagedObject?) {
        guard let codeID = json["uuid"] as? String else {
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
        self.type = type
        self.category = category
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        
        // Prepare to save additional data
        if let service = managedObject as? Service {
            self.service = service
        }
        
        if let nameRu = json["ruName"] as? String {
            self.nameRu = nameRu
        }

        if let nameUa = json["uaName"] as? String {
            self.nameUa = nameUa
        }

        if let nameEng = json["engName"] as? String {
            self.name = nameEng
        }
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
