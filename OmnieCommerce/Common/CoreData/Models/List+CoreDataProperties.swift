//
//  List+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var organization: Organization?

}
