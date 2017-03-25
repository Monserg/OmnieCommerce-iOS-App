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
        
        self.title = organization.name
        self.coordinate = organization.location!
        
        if (organization.addressStreet != nil) {
            self.subtitle = organization.addressStreet!
        } else if (organization.addressCity != nil) {
            self.subtitle = organization.addressCity!
        }
        
//        self.image = organization.lo
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
