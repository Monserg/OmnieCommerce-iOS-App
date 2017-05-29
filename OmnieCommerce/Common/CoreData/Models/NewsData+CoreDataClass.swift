//
//  NewsData+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(NewsData)
public class NewsData: NSManagedObject, InitCellParameters, SearchObject {
    // MARK: - Properties
    var services: [Service]?

    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0

    // Confirm SearchObject Protocol
    var name: String! {
        set {
            self.nameValue = newValue
        }
        
        get {
            return self.nameValue
        }
    }
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], isAction: Bool) {
        // Prepare to save common data
        self.title = json["title"] as! String
        self.codeID = json["uuid"] as! String
        self.isAction = isAction
        self.organizationID = json["organization"] as! String
        self.organizationName = json["orgName"] as! String
        self.name = organizationName
        self.activeDate = (json["date"] as! String).convertToDate(withDateFormat: .NewsDate) as NSDate
        
        if let imageID = json["imageId"] as? String {
            self.imageID = imageID
        }
        
        // Add to NewsData list
        self.newsList = Lists.init(name: (isAction) ? keyNewsActions : keyNewsData, item: self)

        // Prepare to save additional data
        if let message = json["text"] as? String {
            self.text = message
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
