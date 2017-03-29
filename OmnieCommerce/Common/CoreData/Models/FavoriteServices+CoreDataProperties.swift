//
//  FavoriteServices+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension FavoriteServices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteServices> {
        return NSFetchRequest<FavoriteServices>(entityName: "FavoriteServices")
    }

    @NSManaged public var list: NSData?

}
