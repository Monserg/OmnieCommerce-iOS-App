//
//  OrganizationsMapShowModels.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import MapKit

// MARK: - Data models
struct OrganizationsMapShowModels {
    struct PointAnnotations {
        struct RequestModel {
            let organizations: [Organization]
        }
        
        struct ResponseModel {
            let result: [PointAnnotation]
            let regionRect: MKMapRect
        }
        
        struct ViewModel {
            let pointAnnotations: [PointAnnotation]
            let regionRect: MKMapRect
        }
    }
}
