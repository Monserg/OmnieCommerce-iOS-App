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
    var name: String!   // organizationName
    var title: String!
    var logoStringURL: String?
    var activeDate: Date!
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, organizationID: String, organizationName: String, title: String, logoStringURL: String?, activeDate: Date) {
        self.codeID = codeID
        self.organizationID = organizationID
        self.name = organizationName
        self.title = title
        self.logoStringURL = logoStringURL
        self.activeDate = activeDate
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "uuid") as! String
        let organizationID = aDecoder.decodeObject(forKey: "organization") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let name = aDecoder.decodeObject(forKey: "organizationName") as! String
        let logoStringURL = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let activeDate = aDecoder.decodeObject(forKey: "date") as! Date
        
        self.init(codeID: codeID, organizationID: organizationID, organizationName: name, title: title, logoStringURL: logoStringURL, activeDate: activeDate)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "uuid")
        aCoder.encode(organizationID, forKey: "organization")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(name, forKey: "orgName")
        aCoder.encode(logoStringURL, forKey: "imageUrl")
        aCoder.encode(activeDate, forKey: "date")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    
    // Confirm MapObjectBinding Protocol
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.organizationID = dictionary["organization"] as! String
        self.title = dictionary["title"] as! String
        self.name = dictionary["orgName"] as! String
        self.activeDate = (dictionary["date"] as! String).convertToDate(withDateFormat: .NewsDate) as Date

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
