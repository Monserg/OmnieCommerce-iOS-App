//
//  AppSettings+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var lightColorSchema: Bool
    @NSManaged public var pushNotify: Bool
    @NSManaged public var whenCloseApp: Bool
    @NSManaged public var notifyEvent: Bool
    @NSManaged public var soundNotify: Bool
    @NSManaged public var notifyDelay: UInt64
    @NSManaged public var calendarSync: Bool
    @NSManaged public var codeID: String

}
