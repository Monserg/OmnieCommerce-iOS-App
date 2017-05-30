//
//  BusinessCard+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(BusinessCard)
public class BusinessCard: NSManagedObject, InitCellParameters, SearchObject {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "BusinessCardTableViewCell"
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
        
        if let userID = json["userId"] as? String {
            self.userID = userID
        }
        
        if let imageID = json["imageId"] as? String {
            self.imageID = imageID
        }
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let email = json["email"] as? String {
            self.email = email
        }
        
        if let comment = json["comment"] as? String {
            self.comment = comment
        }
        
        if let phones = json["phones"] as? [String], phones.count > 0 {
            self.phones = phones
        }
        
        if let dateCreated = json["createDate"] as? String {
            self.dateCreated = dateCreated.convertToDate(withDateFormat: .DiscountCardDate) as NSDate
        }
        
        self.addToLists(Lists.init(name: listName, item: self))
    }
}
