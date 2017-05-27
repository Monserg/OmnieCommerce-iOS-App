//
//  LocationItem.swift
//  OmnieCommerce
//
//  Created by msm72 on 27.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationItem: PointAnnotationBinding {
    // MARK: - Properties
    var cellIdentifier: String = String()
    var cellHeight: CGFloat = 0.0
    
    var name: String!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var addressCity: String?
    var addressStreet: String?
}
