//
//  Handbook+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension Handbook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Handbook> {
        return NSFetchRequest<Handbook>(entityName: "Handbook")
    }

    @NSManaged public var codeID: String
    @NSManaged public var nameValue: String?
    @NSManaged public var address: String?
    @NSManaged public var phones: [String]?
    @NSManaged public var imageID: String?
    @NSManaged public var tags: [String]?

}
