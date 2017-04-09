//
//  MSMBlackoutView.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMBlackoutView: UIView {
    // MARK: - Class Initialization
    init(inView view: UIView) {
        super.init(frame: view.frame)
        
        setDesignOn(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Custom Functions
    private func setDesignOn(_ view: UIView) {
        self.center = view.center
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        backgroundColor = UIColor(hexString: "#1a232c", withAlpha: 0.95)
        isOpaque = false
    }
}
