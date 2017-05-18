//
//  PasswordStrengthLevelView.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 06.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

enum PasswordStrengthLevel {
    case Weak
    case Reasonable
    case Strong
    case None
}

class PasswordStrengthLevelView: UIView, ErrorMessageViewAnimation {
    // MARK: - Properties
    let lineWidth: CGFloat = 1.0
    var passwordStrengthLevel: PasswordStrengthLevel = .None
    var isVisible: Bool = true

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        if (isVisible) {
            let isLightColorAppSchema = CoreDataManager.instance.appSettings.lightColorSchema

            switch passwordStrengthLevel {
            case .Weak:
                // Draw level line
                let weakLevelLinePath = UIBezierPath()
                weakLevelLinePath.lineWidth = lineWidth
                
                weakLevelLinePath.move(to: CGPoint.init(x: bounds.minX, y: bounds.maxY))
                weakLevelLinePath.addLine(to: CGPoint.init(x: bounds.maxX / 3, y: bounds.maxY))
                let weakLevelLinePathColor = UIColor(hexString: (!isLightColorAppSchema) ? "#ae5454" : "#ae5454", withAlpha: 1.0)!
                weakLevelLinePathColor.setStroke()
                weakLevelLinePath.stroke()
                
                // Draw background line
                let weakBackgroundLinePath = UIBezierPath()
                weakBackgroundLinePath.lineWidth = lineWidth
                
                weakBackgroundLinePath.move(to: CGPoint.init(x: bounds.maxX / 3, y: bounds.maxY))
                weakBackgroundLinePath.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
                let weakBackgroundLinePathColor = UIColor(hexString: (!isLightColorAppSchema) ? "#5e6969" : "#5e6969", withAlpha: 1.0)!
                weakBackgroundLinePathColor.setStroke()
                weakBackgroundLinePath.stroke()
                
            case .Reasonable:
                // Draw level line
                let reasonableLevelLinePath = UIBezierPath()
                reasonableLevelLinePath.lineWidth = lineWidth
                
                reasonableLevelLinePath.move(to: CGPoint.init(x: bounds.minX, y: bounds.maxY))
                reasonableLevelLinePath.addLine(to: CGPoint.init(x: bounds.maxX / 3 * 2, y: bounds.maxY))
                let reasonableLevelLinePathColor = UIColor(hexString: (!isLightColorAppSchema) ? "#d7b278" : "#d7b278", withAlpha: 1.0)!
                reasonableLevelLinePathColor.setStroke()
                reasonableLevelLinePath.stroke()
                
                // Draw background line
                let weakBackgroundLinePath = UIBezierPath()
                weakBackgroundLinePath.lineWidth = lineWidth
                
                weakBackgroundLinePath.move(to: CGPoint.init(x: bounds.maxX / 3 * 2, y: bounds.maxY))
                weakBackgroundLinePath.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
                let weakBackgroundLinePathColor = UIColor(hexString: (!isLightColorAppSchema) ? "#5e6969" : "#5e6969", withAlpha: 1.0)!
                weakBackgroundLinePathColor.setStroke()
                weakBackgroundLinePath.stroke()
                
            case .Strong:
                // Draw level line
                let strongLevelLinePath = UIBezierPath()
                strongLevelLinePath.lineWidth = lineWidth
                
                strongLevelLinePath.move(to: CGPoint.init(x: bounds.minX, y: bounds.maxY))
                strongLevelLinePath.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
                let strongLevelLinePathColor = UIColor(hexString: (!isLightColorAppSchema) ? "#3f916d" : "#3f916d", withAlpha: 1.0)!
                strongLevelLinePathColor.setStroke()
                strongLevelLinePath.stroke()
                
            case .None:
                let oldPath = UIBezierPath()
                oldPath.removeAllPoints()
            }
        }
    }
}
