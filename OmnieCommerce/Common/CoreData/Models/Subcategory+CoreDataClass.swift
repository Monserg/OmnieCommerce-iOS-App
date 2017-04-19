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
public class Subcategory: NSManagedObject, InitCellParameters {
    // MARK: - Properties
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
    convenience init?(json: [String: AnyObject], andType type: DropDownItemType) {
        guard let codeID = json["uuid"] as? String, let name = json["name"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let subcategoryEntity = CoreDataManager.instance.entityForName("Subcategory") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: subcategoryEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save data
        self.codeID = codeID
        self.name = name
        self.type = type
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}
