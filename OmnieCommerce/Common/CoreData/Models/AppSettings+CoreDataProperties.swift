//
//  AppSettings+CoreDataProperties.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData


extension AppSettings {
    // MARK: - Properties
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings");
    }

    @NSManaged public var isThemeDark: Bool
}
