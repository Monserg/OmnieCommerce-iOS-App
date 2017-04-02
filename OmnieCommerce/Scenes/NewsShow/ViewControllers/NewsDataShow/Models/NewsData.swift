//
//  NewsData.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

class NewsData: NSObject, NSCoding, NSCopying, InitCellParameters, SearchObject, MapObjectBinding {
    // MARK: - Properties
    var codeID: String!
    var organizationID: String!
    var name: String!
    var text: String!
    var logoStringURL: String?
    var activeDate: Date!
    var isAction = false
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, organizationID: String, title: String, text: String, logoStringURL: String?, activeDate: Date, isAction: Bool) {
        self.codeID = codeID
        self.organizationID = organizationID
        self.name = title
        self.text = text
        self.logoStringURL = logoStringURL
        self.activeDate = activeDate
        self.isAction = isAction
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "uuid") as! String
        let organizationID = aDecoder.decodeObject(forKey: "organization") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let logoStringURL = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let activeDate = aDecoder.decodeObject(forKey: "date") as! Date
        let isAction = aDecoder.decodeBool(forKey: "promotion")
        
        self.init(codeID: codeID, organizationID: organizationID, title: title, text: text, logoStringURL: logoStringURL, activeDate: activeDate, isAction: isAction)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "uuid")
        aCoder.encode(organizationID, forKey: "organization")
        aCoder.encode(name, forKey: "title")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(logoStringURL, forKey: "imageUrl")
        aCoder.encode(activeDate, forKey: "date")
        aCoder.encode(isAction, forKey: "promotion")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // Confirm MapObjectBinding Protocol
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.organizationID = dictionary["organization"] as! String
        self.name = dictionary["title"] as! String
        self.text = dictionary["text"] as! String
        self.activeDate = (dictionary["date"] as! String).convertToDate(withDateFormat: .NewsDate) as Date
        self.isAction = dictionary["promotion"] as! Bool

        if (dictionary["imageUrl"] as? String != nil) {
            self.logoStringURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["imageUrl"] as! String)"
        }
        
        completion()
    }
    
    // Confirm NSCopying Protocol
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NewsData()
        return copy
    }
}
