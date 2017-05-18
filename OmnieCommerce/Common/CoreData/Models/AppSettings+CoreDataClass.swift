//
//  AppSettings+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(AppSettings)
public class AppSettings: NSManagedObject {
    // MARK: - Custom Functions
    func settingsDidUpload(json: [String: AnyObject]) {
        self.codeID = "AppSettings"
        
        if let lightColorSchema = json["lightColorSchema"] as? Bool {
            self.lightColorSchema = lightColorSchema
        }
        
        if let pushNotify = json["pushNotify"] as? Bool {
            self.pushNotify = pushNotify
        }

        if let whenCloseApp = json["whenCloseApp"] as? Bool {
            self.whenCloseApp = whenCloseApp
        }

        if let notifyEvent = json["notifyEvent"] as? Bool {
            self.notifyEvent = notifyEvent
        }

        if let soundNotify = json["soundNotify"] as? Bool {
            self.soundNotify = soundNotify
        }

        if let calendarSync = json["calendarSync"] as? Bool {
            self.calendarSync = calendarSync
        }

        if let notifyDelay = json["notifyDelay"] as? UInt64 {
            self.notifyDelay = notifyDelay
        }
    }
}
