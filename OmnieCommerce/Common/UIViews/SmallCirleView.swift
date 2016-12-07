//
//  SmallCirleView.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class SmallCirleView: UIView {
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(object: "\(type(of: self)): \(#function) run. Initialization frame = \(frame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print(object: "\(type(of: self)): \(#function) run. Initialization frame = \(frame)")
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Rect = \(rect)")
        
        // Get the Graphics Context
        let contextFillView                     =   UIGraphicsGetCurrentContext()
        let contextLineView                     =   UIGraphicsGetCurrentContext()
        let lineViewHeightPortrait: Double      =   Double(rect.size.height - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance
        let fillViewHeightPortrait: CGFloat     =   CGFloat(lineViewHeightPortrait - Config.Constants.fillViewLineViewDistance)
        let lineViewHeightLandscape: Double     =   Double(rect.size.height - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance
        let fillViewHeightLandscape: CGFloat    =   CGFloat(lineViewHeightLandscape - Config.Constants.fillViewLineViewDistance)
        
        // Set the circle outerline-colour
        UIColor.darkCyan.set()
        
        // Create Fill Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let centerFillViewPortrait = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(fillViewHeightPortrait) - Config.Constants.fillViewSmallRadiusPortrait))
            
            contextFillView!.addArc(center: centerFillViewPortrait, radius: CGFloat(Config.Constants.fillViewSmallRadiusPortrait), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        } else {
            let centerFillViewLandscape = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(fillViewHeightLandscape) - Config.Constants.fillViewSmallRadiusLandscape))
            
            contextFillView!.addArc(center: centerFillViewLandscape, radius: CGFloat(Config.Constants.fillViewSmallRadiusLandscape), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        }
        
        contextFillView!.fillPath()
        
        // Set the circle outerline-width
        contextLineView!.setLineWidth(Config.Constants.lineViewThickness)
        
        // Set the circle outerline-colour
        UIColor.veryDarkGrayishBlue38.set()
///        UIColor.white.set()
        
        // Create Line Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let centerLineViewPortrait = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(lineViewHeightPortrait) - Config.Constants.fillViewSmallRadiusPortrait))
            
            contextLineView!.addArc(center: centerLineViewPortrait, radius: CGFloat(Config.Constants.fillViewSmallRadiusPortrait), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        } else {
            let centerLineViewLandscape = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(lineViewHeightLandscape) - Config.Constants.fillViewSmallRadiusLandscape))

            contextLineView!.addArc(center: centerLineViewLandscape, radius: CGFloat(Config.Constants.fillViewSmallRadiusLandscape), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        }
        
        contextLineView!.strokePath()
    }
}
