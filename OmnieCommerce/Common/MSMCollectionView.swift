//
//  MSMCollectionView.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMCollectionView: UICollectionView {
    // MARK: - Properties
    var collectionViewControllerManager: MSMCollectionViewControllerManager! {
        didSet {
            self.delegate = collectionViewControllerManager
            self.dataSource = collectionViewControllerManager
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clear
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
