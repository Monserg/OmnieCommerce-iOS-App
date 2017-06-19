
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
        let screenHeight = (UIApplication.shared.statusBarOrientation.isPortrait) ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        return screenHeight / 667.0
    }

    var widthRatio: CGFloat {
        let screenWidth = (UIApplication.shared.statusBarOrientation.isPortrait) ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        return screenWidth / 375.0
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
        return CGFloat(degreeValue * .pi / 180.0)
    }
    
    func didShow() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    
    func didShow(_ value: Bool, withConstraint constraint: NSLayoutConstraint) {
        guard (isHidden && value) || (!isHidden && !value) else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            constraint.constant = (value) ? 0 : -self.frame.height
            self.layoutIfNeeded()
        }, completion: { success in
            UIView.animate(withDuration: 0.3, animations: {
                self.isHidden = (value) ? false : true
            })
        })
    }

    func didHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
    }
    
    func isSquare() -> Bool {
        return self.frame.height == self.frame.width
    }
    
    func constraintDidUpdate( _ constraint: NSLayoutConstraint, withNewMultiplier newMultiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = constraint.didUpdate(withNewMultiplier: newMultiplier)
        
        self.removeConstraint(constraint)
        self.addConstraint(newConstraint)
        
        self.layoutIfNeeded()
        
        return newConstraint
    }
    
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView, let image = imageView.image {
                imageView.tintColor = UIColor.veryLightOrange //color
                imageView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    func draw(fromPoint startPoint: CGFloat, withFinishOffset finishOffset: CGFloat, andNewSize size: CGSize) {
        frame = CGRect.init(origin: frame.origin, size: CGSize.init(width: size.width - (startPoint + finishOffset), height: frame.height))
    }
    
    // Order Creae & Move TimeSheetView
    func convertToPeriod() {
        period.hourStart = Int16((self.frame.minY) / CGFloat(period.cellHeight)) + period.workHourStart
        period.hourEnd = Int16((self.frame.maxY) / CGFloat(period.cellHeight)) + period.workHourStart
       
        var minuteStart = Int16(self.frame.minY) % Int16(period.cellHeight)
        var minuteEnd = Int16(self.frame.maxY) % Int16(period.cellHeight)
        
        // Down direction
        if let view = self as? TimeSheetView, view.isDirectionDown {
//            if (minuteStart >= 60) {
//                period.hourStart += 1
//            }
            
            if (minuteStart < 0) {
                period.hourStart -= 1
                minuteStart += 60
//                minuteEnd = minuteStart - Int16(self.frame.height)
            }
            
            if (minuteEnd < 0) {
                period.hourEnd -= 1
                minuteEnd += 56
//                minuteEnd = minuteStart + Int16(self.frame.height)
            }
        }
        
        // Up direction
            /*
        else {
            if (minuteStart < 0) {
                period.hourStart -= 1
                minuteStart += 60
            }
            
            if (minuteEnd < 0) {
                period.hourEnd -= 1
                minuteEnd += 56
            }
        }
        */
        
        period.minuteStart = minuteStart
        period.minuteEnd = minuteEnd

        
        
////        if let view = self as? TimeSheetView, view.isDirectionDown, minuteStart < 0 {
////            period.hourStart -= 1
////            minuteStart += 56
////        }
//        
//        if let view = self as? TimeSheetView, !view.isDirectionDown, minuteStart < 0 {
//            period.hourStart -= 1
//            minuteStart += 60
//            minuteEnd = minuteStart - Int16(self.frame.height)
//        }
//        
//        period.hourEnd = Int16((self.frame.maxY) / CGFloat(period.cellHeight)) + period.workHourStart
//        
//        print(object: "minuteEnd = \(minuteEnd)")
//        
////        if let view = self as? TimeSheetView, !view.isDirectionDown, minuteEnd < 0 {
////            period.hourEnd -= 1
////            minuteEnd += 60
////        }
//
//        if let view = self as? TimeSheetView, view.isDirectionDown, minuteEnd < 0 {
//            period.hourEnd -= 1
//            minuteEnd += 56
//            minuteStart = minuteEnd - Int16(self.frame.height)
//        }

    }
    
    // For time
    func convertToCurrentTime() -> String {
        let hour = Int16((self.frame.midY) / CGFloat(period.cellHeight)) + period.workHourStart
        let minute = Int16(Float(Int16(self.frame.midY) % Int16(period.cellHeight) + period.workMinuteStart - Int16(period.timeOffset)) * period.scale)

        return "\(String(hour).twoNumberFormat()):\(String(minute).twoNumberFormat())"
    }

}


extension CGColor {
    var UIColor: UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}


extension NSLayoutConstraint {
    func didUpdate(withNewMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

