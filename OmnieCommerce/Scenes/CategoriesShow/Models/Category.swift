//
//  Category.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import CoreData
import SwiftyJSON
import Foundation

class Category: NSObject, NSCoding, NSCopying, InitCellParameters, MapObjectBinding {
    // MARK: - Properties
    var codeID: String!
    var name: String!
    var imagePath: String?
    var subcategories: [Subcategory]!

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "CategoryCollectionViewCell"
    var cellHeight: CGFloat = 102.0

    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, name: String, imagePath: String?, subcategories: [Subcategory]) {
        self.codeID         =   codeID
        self.name           =   name
        self.imagePath      =   imagePath
        self.subcategories  =   subcategories
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID          =   aDecoder.decodeObject(forKey: "codeID") as! String
        let name            =   aDecoder.decodeObject(forKey: "name") as! String
        let imagePath       =   aDecoder.decodeObject(forKey: "imagePath") as? String
        let subcategories   =   aDecoder.decodeObject(forKey: "subcategories") as! [Subcategory]
        
        self.init(codeID: codeID, name: name, imagePath: imagePath, subcategories: subcategories)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imagePath, forKey: "imagePath")
        aCoder.encode(subcategories, forKey: "subcategories")
    }

    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }

    
    // Confirm MapObjectBinding Protocol
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.name = dictionary["name"] as! String
        
        if (dictionary["logo"] as? String != nil) {
            self.imagePath = "http://\(dictionary["logo"] as! String)"
        }
        
        // Map Subcategory list
        let responseSubcategories = dictionary["subCategories"] as! NSArray
        subcategories = [Subcategory.init(codeID: "All-Subcategories-ID", name: "By all subcategories".localized())]
        
        guard responseSubcategories.count > 0 else {
            completion()
            return
        }
        
        for dictionary in responseSubcategories {
            let subcategory = Subcategory.init()
            subcategory.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
            subcategories.append(subcategory)
        }

        completion()
    }
    
    // Confirm NSCopying Protocol
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Category()
        return copy
    }
}
