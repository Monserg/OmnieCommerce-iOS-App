//
//  UIView+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 21.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - Properties
    var heightRatio: CGFloat {
        return ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / self.frame.height
    }

    var widthRatio: CGFloat {
        return ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / self.frame.width
    }

    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return layer.borderColor?.UIColor }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue  }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {  layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return layer.shadowColor?.UIColor }
    }
    
    @IBInspectable var _clipsToBounds: Bool {
        set { clipsToBounds = newValue }
        get { return clipsToBounds }
    }
        

    // MARK: - Custom Functions
    func releasePrint(object: Any) {
        Swift.print(object)
    }
    
    func print(object: Any) {
        #if DEBUG
            Swift.print(object)
        #endif
    }
    
    func degreeToRadian(degreeValue: Double) -> CGFloat {
        return CGFloat(degreeValue * M_PI / 180.0)
    }
    
    func didShow() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha  =   1
        })
    }
    
    func didHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha  =   0
        })
    }
}


extension CGColor {
    var UIColor: UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}
