//
//  DiscountCard+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(DiscountCard)
public class DiscountCard: NSManagedObject, InitCellParameters, SearchObject  {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "DiscountCardCollectionViewCell"
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
        
        if let code = json["code"] as? String {
            self.code = code
        }

        if let format = json["format"] as? String {
            self.format = format
        }

        if let dateCreated = json["createDate"] as? String {
            self.dateCreated = dateCreated.convertToDate(withDateFormat: .DiscountCardDate) as NSDate
        }

        self.addToLists(Lists.init(name: listName, item: self))
    }
}
