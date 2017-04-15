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
public class Subcategory: NSManagedObject, DropDownItem, InitCellParameters {
    // MARK: - Properties
    // Confirm DropDownItem Protocol
    var codeID: String! {
        get {
            return self.codeIDValue
        }
        
        set {
            self.codeIDValue = newValue
        }
    }
    
    var name: String! {
        get {
            return self.nameValue
        }
        
        set {
            self.nameValue = newValue
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
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("Subcategory"), insertInto: CoreDataManager.instance.managedObjectContext)
        
        self.type = .Subcategory
    }
    
    convenience init(codeID: String, name: String) {
        self.init(entity: CoreDataManager.instance.entityForName("Subcategory"), insertInto: CoreDataManager.instance.managedObjectContext)

        self.codeID = codeID
        self.name = name
        self.type = .Subcategory
    }

    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Subcategory: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as? String ?? "XXX"
        self.name = dictionary["name"] as? String ?? "XXX"
        
        completion()
    }
}
