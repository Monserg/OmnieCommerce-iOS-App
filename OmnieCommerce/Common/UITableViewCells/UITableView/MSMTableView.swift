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
    var tableViewControllerManager: MSMTableViewControllerManager!

    // Register cells from Xib
    var cellIdentifiers: [String]! {
        didSet {
            for identifier in cellIdentifiers! {
                self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            }
        }
    }

    
    // MARK: - Class Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.tableViewControllerManager             =   MSMTableViewControllerManager()
        self.tableViewControllerManager.tableView   =   self
        self.delegate                               =   tableViewControllerManager
        self.dataSource                             =   tableViewControllerManager
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
        
        self.flashScrollIndicators()
    }
}
