//
//  UIScrollView+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 27.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setScrollIndicatorColor(_ color: UIColor) {
        let verticalIndicator                   =   (self.subviews[(self.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor       =   color
        
//        let horizontalIndicator                 =   (self.subviews[(self.subviews.count - 2)] as! UIImageView)
//        horizontalIndicator.backgroundColor     =   color
        
        
//        for view in self.subviews {
//            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView, let image = imageView.image {
//                imageView.tintColor     =   color
//                imageView.image         =   image.withRenderingMode(.alwaysTemplate)
//            }
//        }
//        
//        self.flashScrollIndicators()
    }
}
