//
//  News+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var list: NSData?

}
