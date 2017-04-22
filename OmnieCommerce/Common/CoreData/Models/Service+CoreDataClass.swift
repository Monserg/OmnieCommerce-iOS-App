//
//  Service+CoreDataClass.swift
//  OmnieCommerce
//
//  Created by msm72 on 22.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Service)
public class Service: NSManagedObject, InitCellParameters, PointAnnotationBinding {
    // MARK: - Properties
    var category: Category?
    var needBackgroundColorSet: Bool = false
    var isNameNeedHide: Bool = false
    var isCommonProfile: Bool = true
    
    // From common API response
    var codeID: String!
    var organizationName: String?
    var logoURL: String?
    var headerURL: String?
    var rating: Double?
    var isFavorite: Bool = false
    
    // Confirm SearchObject Protocol
    var name: String!
    
    // Confirm PointAnnotationBinding Protocol
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var addressCity: String?
    var addressStreet: String?
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "ServiceTableViewCell"
    var cellHeight: CGFloat = 96.0
    
    // From full API response
    var prices: [ServicePrice]?

}
