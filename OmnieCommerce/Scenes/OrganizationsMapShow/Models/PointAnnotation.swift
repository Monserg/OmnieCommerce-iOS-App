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
    var isRegionChange = false
    
    
    // MARK: - Custom Functions
    func didUpdate(fromViewModel viewModel: LocationData) {
        subtitle            =   viewModel.address
        coordinate          =   viewModel.coordinate ?? CLLocationCoordinate2D.init()
    }
    
    func didFill(fromPointAnnotation pointAnnotation: PointAnnotation) {
        self.title          =   pointAnnotation.title
        self.subtitle       =   pointAnnotation.subtitle
        self.coordinate     =   pointAnnotation.coordinate
        self.image          =   pointAnnotation.image
    }
}
