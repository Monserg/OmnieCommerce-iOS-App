//
//  NewsData+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension NewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsData> {
        return NSFetchRequest<NewsData>(entityName: "NewsData")
    }

    @NSManaged public var activeDate: NSDate
    @NSManaged public var codeID: String
    @NSManaged public var imageID: String?
    @NSManaged public var isAction: Bool
    @NSManaged public var organizationID: String
    @NSManaged public var organizationName: String
    @NSManaged public var text: String?
    @NSManaged public var title: String
    @NSManaged public var newsList: Lists?

}
