//
//  NewsData+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.04.17.
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
    @NSManaged public var isAction: Bool
    @NSManaged public var logoStringURL: String?
    @NSManaged public var name: String
    @NSManaged public var organizationID: String
    @NSManaged public var text: String?
    @NSManaged public var title: String

}
