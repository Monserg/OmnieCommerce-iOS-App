//
//  MapView.swift
//  OmnieCommerce
//
//  Created by msm72 on 25.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import MapKit

class MapView: MKMapView {
    // MARK: - Class Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutMargins = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 8)
    }
}
