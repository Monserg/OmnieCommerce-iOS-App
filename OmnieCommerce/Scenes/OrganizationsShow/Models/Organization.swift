
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

struct Organization: InitCellParameters, SearchObject {
    // MARK: - Properties
    let codeID: Int!
    var name: String!
    let category: Category!
    let location: CLLocationCoordinate2D!
    var addressCity: String?
    var addressStreet: String?
    var logoURL: String?
    var headerURL: String?
    var rating              =   0.0
    var isFavorite: Bool    =   false
    var phones: [String]?
    var schedule: Schedule!
    
    var cellIdentifier: String
    var cellHeight: CGFloat
}
