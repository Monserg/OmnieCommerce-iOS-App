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
    var headears: [String]?
    var hasHeaders = false
    
    var tableViewControllerManager: MSMTableViewControllerManager! {
        didSet {
            self.delegate = tableViewControllerManager
            self.dataSource = tableViewControllerManager
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.setScrollIndicatorColor(color: UIColor.veryLightOrange)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }
}
