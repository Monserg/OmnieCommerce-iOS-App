//
//  Lists+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

@objc(Lists)
public class Lists: NSManagedObject {
    // MARK: - Class Initialization
    convenience init(name: String, item: NSManagedObject) {
        // Create Entity
        let entityLists = CoreDataManager.instance.entityForName("Lists")!
        self.init(entity: entityLists, insertInto: CoreDataManager.instance.managedObjectContext)
        
        // Prepare to save common data
        self.name = name
        
        if let news = item as? NewsData {
            self.addToNews(news)
        }
        
        if let category = item as? Category {
            self.addToCategories(category)
        }
        
        if let organization = item as? Organization {
            self.addToOrganizations(organization)
        }

        if let service = item as? Service {
            self.addToServices(service)
        }
        
        if let order = item as? Order {
            self.addToOrders(order)
        }
        
        if let handbook = item as? Handbook {
            self.addToHandbooks(handbook)
        }

        if let discountCard = item as? DiscountCard {
            self.addToDiscountCards(discountCard)
        }
    }
}
