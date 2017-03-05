//
//  MSMTableView.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTableView: UITableView {
    // MARK: - Properties
    var tableViewControllerManager: MSMTableViewControllerManager! {
        didSet {
            self.delegate       =   tableViewControllerManager
            self.dataSource     =   tableViewControllerManager
        }
    }
    
    
    // Register cells from Xib
    var cellIdentifiers: [(code: String, height: CGFloat)]! {
        didSet {
            for identifier in cellIdentifiers! {
                self.register(UINib(nibName: identifier.code, bundle: nil), forCellReuseIdentifier: identifier.code)
                
//                self.estimatedRowHeight     =   identifier.height
//                self.rowHeight              =   UITableViewAutomaticDimension

            }
        }
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }
    
    
    // MARK: - Custom Functions
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView, let image = imageView.image {
                imageView.tintColor     =   color
                imageView.image         =   image.withRenderingMode(.alwaysTemplate)
            }
        }
        
//        self.flashScrollIndicators()
    }
}
