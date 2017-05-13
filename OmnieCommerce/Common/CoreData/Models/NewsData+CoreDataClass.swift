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
public class NewsData: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0

    var services: [Service]?
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject], isAction: Bool) {
        guard let codeID = json["uuid"] as? String, let organizationName = json["orgName"] as? String, let title = json["title"] as? String, let date = json["date"] as? String, let organizationID = json["organization"] as? String else {
            return nil
        }

        // Check Entity available in CoreData
        guard let newsDataEntity = CoreDataManager.instance.entityForName("NewsData") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: newsDataEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.title = title
        self.codeID = codeID
        self.isAction = isAction
        self.organizationID = organizationID
        self.organizationName = organizationName
        self.activeDate = date.convertToDate(withDateFormat: .NewsDate) as NSDate
        
        if let imageID = json["imageUrl"] as? String {
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
