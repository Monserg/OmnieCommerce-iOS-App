//
//  ModalView.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

class ModalView: CustomView {
    // MARK: - Class Initialization
    init(inView view: UIView, withHeight height: CGFloat) {
        let widthRatio = ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / view.frame.width
        let heightRatio = ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / view.frame.height
        let newFrame = CGRect.init(x: 0, y: 0, width: 345 / widthRatio, height: height / heightRatio)

        super.init(frame: newFrame)
        
        self.backgroundColor = UIColor.clear
        view.addSubview(self)
        self.center = view.center
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
