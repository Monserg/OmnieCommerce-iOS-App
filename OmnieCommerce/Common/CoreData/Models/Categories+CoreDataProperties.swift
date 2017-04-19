//
//  Categories+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var list: NSData

}
