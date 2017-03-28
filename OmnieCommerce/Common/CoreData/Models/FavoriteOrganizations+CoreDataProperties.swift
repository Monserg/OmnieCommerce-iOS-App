//
//  FavoriteOrganizations+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension FavoriteOrganizations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteOrganizations> {
        return NSFetchRequest<FavoriteOrganizations>(entityName: "FavoriteOrganizations")
    }

    @NSManaged public var list: NSData?

}
