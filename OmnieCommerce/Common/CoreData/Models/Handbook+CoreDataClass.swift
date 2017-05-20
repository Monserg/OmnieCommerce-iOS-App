//
//  Handbook+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Handbook)
public class Handbook: NSManagedObject, InitCellParameters, SearchObject {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "HandbookTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    // Confirm SearchObject Protocol
    var name: String! {
        set {
            self.nameValue = newValue
        }
        
        get {
            return self.nameValue
        }
    }
    
    
    // MARK: - Custom Functions
    func profileDidUpload(json: [String: AnyObject], forList listName: String) {
        // Prepare to save common data
        if let codeID = json["uuid"] as? String {
            self.codeID = codeID
        }
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let address = json["address"] as? String {
            self.address = address
        }
        
        if let imageID = json["imgId"] as? String {
            self.imageID = imageID
        }
        
        // Phones
        if let phones = json["phones"] as? [String], phones.count > 0 {
            self.phones = phones
        }

        // Tags
        if let tags = json["tags"] as? [String], tags.count > 0 {
            self.tags = tags
        }
    }
}
