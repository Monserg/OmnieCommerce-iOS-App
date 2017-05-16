//
//  Schedule+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Schedule)
public class Schedule: NSManagedObject, InitCellParameters {
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ScheduleTableViewCell"
    var cellHeight: CGFloat = 31.0

    
    // MARK: - Class Initialization
    convenience init(codeID: String, name: String, day: UInt16, workTimeStart: String!, workTimeEnd: String!, launchTimeStart: String?, launchTimeEnd: String?, organization: Organization?) {
        // Create Entity
        self.init(entity: CoreDataManager.instance.entityForName("Schedule")!, insertInto: CoreDataManager.instance.managedObjectContext)

        self.codeID = codeID
        self.name = name
        self.day = day
        self.workTimeStart = workTimeStart
        self.workTimeEnd = workTimeEnd
        self.launchTimeStart = launchTimeStart
        self.launchTimeEnd = launchTimeEnd
        self.organization = organization
    }

    convenience init?(json: [String: AnyObject], andOrganization organization: Organization) {
        guard let codeID = json["uuid"] as? String, let day = json["day"] as? UInt16, let workTimeStart = json["workStart"] as? String, let workTimeEnd = json["workEnd"] as? String else {
            return nil
        }
        
        
        // Check Entity available in CoreData
        guard let scheduleEntity = CoreDataManager.instance.entityForName("Schedule") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: scheduleEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.codeID = codeID
        self.day = day
        self.name = day.convertToScheduleString()
        self.workTimeStart = workTimeStart
        self.workTimeEnd = workTimeEnd
        self.organization = organization
        
        if let breakStart = json["breakStart"] as? String {
            self.launchTimeStart = breakStart
        }
        
        if let breakEnd = json["breakEnd"] as? String {
            self.launchTimeEnd = breakEnd
        }
        
        if let organizationID = json["orgUuid"] as? String {
            self.organizationID = organizationID
        }

        if (self.launchTimeStart != nil) {
            let _ = Schedule.init(codeID: self.codeID + "-launch",
                                  name: "Lunch break".localized(),
                                  day: 0,
                                  workTimeStart: self.launchTimeStart!,
                                  workTimeEnd: self.launchTimeEnd!,
                                  launchTimeStart: nil,
                                  launchTimeEnd: nil,
                                  organization: organization)
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
