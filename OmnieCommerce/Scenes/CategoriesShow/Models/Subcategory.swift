//
//  Subcategory.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class Subcategory: NSObject, NSCoding, DropDownItem, InitCellParameters {
    // MARK: - Properties
    // Confirm DropDownItem Protocol
    var codeID: String!
    var name: String!
    var type: DropDownItemType! = .Subcategory
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "DropDownTableViewCell"
    var cellHeight: CGFloat = Config.Constants.dropDownCellHeight

    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }

    init(codeID: String, name: String) {
        self.codeID = codeID
        self.name = name
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String

        self.init(codeID: codeID, name: name)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Subcategory: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.name = dictionary["name"] as! String
        
        completion()
    }
}
