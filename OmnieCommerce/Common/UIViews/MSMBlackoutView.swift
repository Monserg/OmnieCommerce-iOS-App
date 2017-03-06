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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        didSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        didSetup()
    }
    
    
    // MARK: - Custom Functions
    func didSetup() {
        let window          =   UIApplication.shared.keyWindow?.rootViewController!
        translatesAutoresizingMaskIntoConstraints   =   false
        
        topAnchor.constraint(equalTo: window!.view.topAnchor, constant: 0).isActive         =   true
        bottomAnchor.constraint(equalTo: window!.view.bottomAnchor, constant: 0).isActive   =   true
        leftAnchor.constraint(equalTo: window!.view.leftAnchor, constant: 0).isActive       =   true
        rightAnchor.constraint(equalTo: window!.view.rightAnchor, constant: 0).isActive     =   true
        
        backgroundColor     =   UIColor(hexString: "#1a232c", withAlpha: 0.85)
        isOpaque            =   false
    }
}
