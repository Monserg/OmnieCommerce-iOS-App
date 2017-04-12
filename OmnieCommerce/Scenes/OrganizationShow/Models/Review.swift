//
//  Review.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review: NSObject, NSCoding, InitCellParameters {
    // MARK: - Properties
    var codeID: String!
    var name: String!
    var rating: Double!
    var content: String!
    var dateCreate: Date!
    var imagePath: String?
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ReviewCollectionViewCell"
    var cellHeight: CGFloat = 143.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, name: String, rating: Double, content: String, dateCreate: Date, imagePath: String?) {
        self.codeID = codeID
        self.name = name
        self.rating = rating
        self.content = content
        self.dateCreate = dateCreate
        self.imagePath = imagePath
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "codeID") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let rating = aDecoder.decodeObject(forKey: "rating") as! Double
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let dateCreate = aDecoder.decodeObject(forKey: "dateCreate") as! Date
        let imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
        
        self.init(codeID: codeID, name: name, rating: rating, content: content, dateCreate: dateCreate, imagePath: imagePath)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "codeID")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(dateCreate, forKey: "dateCreate")
        aCoder.encode(imagePath, forKey: "imagePath")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension Review: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.name = dictionary["name"] as! String
        self.rating = dictionary["rating"] as! Double
        self.content = dictionary["content"] as! String
        self.dateCreate = (dictionary["dateCreate"] as! String).convertToDate(withDateFormat: .ResponseDate)
        
        if (dictionary["URL"] as? String != nil) {
            self.imagePath = dictionary["URL"] as? String
        }
        
        completion()
    }
}


// MARK: - NSCopying
extension Review: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Review()
        return copy
    }
}
