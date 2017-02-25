//
//  PointAnnotation.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 12.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotation: MKPointAnnotation {
    // MARK: - Properties
    var image: UIImage?
    
    
    // MARK: - Class Initialization
    init(fromOrganization organization: Organization) {
        super.init()
        
        self.title          =   organization.name
        self.subtitle       =   "\(organization.addressCity ?? ""), \(organization.addressStreet ?? "")"
        self.coordinate     =   organization.location
//        self.image          =   organization.lo
    }
}
