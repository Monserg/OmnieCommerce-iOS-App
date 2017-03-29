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
    init(fromItem item: PointAnnotationBinding) {
        super.init()
        
        self.title = item.name
        self.coordinate = CLLocationCoordinate2D.init(latitude: item.latitude!, longitude: item.longitude!)
        
        if (item.addressStreet != nil) {
            self.subtitle = item.addressStreet!
        } else if (item.addressCity != nil) {
            self.subtitle = item.addressCity!
        }
    }
    
    deinit {
        print("\(type(of: self)) deinit")
    }
}
