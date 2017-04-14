//
//  NewsData.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

class NewsData: NSObject, NSCoding, InitCellParameters, SearchObject {
    // MARK: - Properties
    var codeID: String!
    var organizationID: String!
    var title: String!
    var text: String!
    var logoStringURL: String?
    var activeDate: Date!
    var services: [Service]?
    var isAction: Bool = false

    // Confirm SearchObject Protocol
    var name: String!   // organizationName

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
    }
    
    init(codeID: String, organizationID: String, organizationName: String, title: String, text: String, logoStringURL: String?, activeDate: Date, services: [Service]) {
        self.codeID = codeID
        self.organizationID = organizationID
        self.name = organizationName
        self.title = title
        self.text = text
        self.logoStringURL = logoStringURL
        self.activeDate = activeDate
        self.services = services
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let codeID = aDecoder.decodeObject(forKey: "uuid") as! String
        let organizationID = aDecoder.decodeObject(forKey: "organization") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let text = aDecoder.decodeObject(forKey: "text") as! String
        let name = aDecoder.decodeObject(forKey: "organizationName") as! String
        let logoStringURL = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let activeDate = aDecoder.decodeObject(forKey: "date") as! Date
        let services = aDecoder.decodeObject(forKey: "services") as! [Service]
        
        self.init(codeID: codeID, organizationID: organizationID, organizationName: name, title: title, text: text,logoStringURL: logoStringURL, activeDate: activeDate, services: services)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(codeID, forKey: "uuid")
        aCoder.encode(organizationID, forKey: "organization")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(name, forKey: "orgName")
        aCoder.encode(logoStringURL, forKey: "imageUrl")
        aCoder.encode(activeDate, forKey: "date")
        aCoder.encode(services, forKey: "services")
    }
    
    
    // MARK: - Class Functions
    deinit {
        print("\(type(of: self)) deinit")
    }
}


// MARK: - MapObjectBinding
extension NewsData: MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ())) {
        self.codeID = dictionary["uuid"] as! String
        self.organizationID = dictionary["organization"] as! String
        self.title = dictionary["title"] as! String
        self.name = dictionary["orgName"] as! String
        self.activeDate = (dictionary["date"] as! String).convertToDate(withDateFormat: .NewsDate) as Date

        if (dictionary["text"] as? String != nil) {
            self.text = dictionary["text"] as? String
        }
        
        if (dictionary["imageUrl"] as? String != nil) {
            self.logoStringURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(dictionary["imageUrl"] as! String)"
        }
        
        // Map Services list
        let responseServices = dictionary["services"] as? NSArray
        
        guard responseServices != nil else {
            completion()
            return
        }
        
        if (responseServices!.count > 0) {
            services = [Service]()
            
            for dictionary in responseServices! {
                let service = Service.init(withCommonProfile: true)
                service.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
                services!.append(service)
            }
        }

        completion()
    }
}


// MARK: - NSCopying
extension NewsData: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NewsData()
        return copy
    }
}
