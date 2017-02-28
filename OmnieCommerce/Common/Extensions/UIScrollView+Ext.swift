//
//  UIScrollView+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 27.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension UIScrollView {
    func indicatorDidChange(_ color: UIColor) {
        for view in self.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView {
                imageView.backgroundColor       =   color
                imageView.layer.cornerRadius    =   imageView.bounds.width / 2
            }
        }
    }
}
