//
//  OrganizationsMapShowWorker.swift
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

class OrganizationsMapShowWorker {
    // MARK: - Properties
    var regionRect  =   MKMapRectNull
    var points      =   [PointAnnotation]()
    let delta       =   10000.0

    
    // MARK: - Custom Functions. Business Logic
    func pointAnnotationsDidLoad(fromItems items: [PointAnnotationBinding]) {
        for item in items {
            let point       =   PointAnnotation.init(fromItem: item)
            let pointCenter =   MKMapPointForCoordinate(point.coordinate)
            let pointRect   =   MKMapRectMake(pointCenter.x - delta, pointCenter.y - delta, delta * 2, delta * 2)
            
            regionRect      =   MKMapRectUnion(regionRect, pointRect)
            points.append(point)
        }
    }
}
