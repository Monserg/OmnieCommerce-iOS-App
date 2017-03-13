//
//  AppUser+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser");
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var appName: String?
    @NSManaged public var birthday: NSDate?
    @NSManaged public var codeID: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var isAuthorized: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?

}
