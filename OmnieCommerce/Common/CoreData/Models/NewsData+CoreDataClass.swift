//
//  NewsData+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(NewsData)
public class NewsData: NSManagedObject, InitCellParameters {
    // MARK: - Properties
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "NewsDataTableViewCell"
    var cellHeight: CGFloat = 96.0

    
    var services: [Service]?
    
    
    // MARK: - Class Initialization
    convenience init?(json: [String: AnyObject]) {
        guard let codeID = json["uuid"] as? String, let name = json["orgName"] as? String, let title = json["title"] as? String, let date = json["date"] as? String, let organizationID = json["organization"] as? String else {
            return nil
        }
        
        // Check Entity available in CoreData
        guard let newsDataEntity = CoreDataManager.instance.entityForName("NewsData") else {
            return nil
        }
        
        // Create Entity
        self.init(entity: newsDataEntity, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save data
        self.codeID = codeID
        self.name = name
        self.title = title
        self.activeDate = date.convertToDate(withDateFormat: .NewsDate) as NSDate
        self.organizationID = organizationID
        
        if (json["text"] as? String != nil) {
            self.text = json["text"] as? String
        }
        
        if (json["imageUrl"] as? String != nil) {
            self.logoStringURL = "\(MSMRestApiManager.instance.appHostURL.absoluteString)\(json["imageUrl"] as! String)"
        }
        
        // Map Services list
//        let responseServices = json["services"] as? NSArray
//        
//        guard responseServices != nil else {
//            return
//        }
//        
//        if (responseServices!.count > 0) {
//            services = [Service]()
//            
//            for dictionary in responseServices! {
//                let service = Service.init(withCommonProfile: true)
//                service.didMap(fromDictionary: dictionary as! [String : Any], completion: { _ in })
//                services!.append(service)
//            }
//        }

        
        
        
//        self.subcategories = NSSet()

        //        for json in subcategoriesList {
//            let subcategory = Subcategory.init(json: json as! [String: AnyObject], andType: .Subcategory)
//            subcategory!.category = self
//            
//            self.subcategories!.adding(subcategory!)
//        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
