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
        self.coordinate = CLLocationCoordinate2D.init(latitude: organization.latitude!, longitude: organization.longitude!)
        
        if (organization.addressStreet != nil) {
            self.subtitle = organization.addressStreet!
        } else if (organization.addressCity != nil) {
            self.subtitle = organization.addressCity!
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
