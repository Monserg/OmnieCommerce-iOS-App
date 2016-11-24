//
//  BigCirleView.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Device

@IBDesignable class BigCirleView: UIView {
    // MARK: - Properties
    // BigTopView height = auto calculate
    // Line cirle radius = view.height - 14
    // Fill area height = line.radius - 13
    // Fill area radius = 568

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        let lineViewRadiusPortrait: Double          =   Double(rect.size.height) - 3.0 - 3.0
        let fillViewRadiusPortrait: Double          =   360
        let fillViewHeightPortrait: CGFloat         =   CGFloat(lineViewRadiusPortrait - 13.0)
        let lineViewRadiusLandscape: Double         =   Double(rect.size.width) - 3.0 - 3.0
        let fillViewRadiusLandscape: Double         =   289
        let fillViewWidthLandscape: CGFloat         =   CGFloat(lineViewRadiusLandscape - 13.0)
        let lineViewThickness: CGFloat              =   3
        
        let contextFillView = UIGraphicsGetCurrentContext()
        let contextLineView = UIGraphicsGetCurrentContext()
        
        // Set the circle outerline-colour
        Config.Colors.darkCyan?.set()
        
        // Create Fill Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let centerFillViewPortrait = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(fillViewHeightPortrait) - fillViewRadiusPortrait))
            
            contextFillView!.addArc(center: centerFillViewPortrait, radius: CGFloat(fillViewRadiusPortrait), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        } else {
            let centerFillViewLandscape = CGPoint(x: CGFloat(Double(fillViewWidthLandscape) - fillViewRadiusLandscape), y: frame.size.height / 2)
            contextFillView!.addArc(center: centerFillViewLandscape, radius: CGFloat(fillViewRadiusLandscape), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        }
        
        contextFillView!.fillPath()
        
        // Set the circle outerline-width
        contextLineView!.setLineWidth(lineViewThickness)
        
        // Set the circle outerline-colour
        Config.Colors.veryDarkGrayishBlue38?.set()
        
        // Create Line Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let centerLineViewPortrait = CGPoint(x: frame.size.width / 2, y: CGFloat(Double(fillViewHeightPortrait) - fillViewRadiusPortrait + 13.0))
            contextLineView!.addArc(center: centerLineViewPortrait, radius: CGFloat(fillViewRadiusPortrait), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        } else {
            let centerLineViewLandscape = CGPoint(x: CGFloat(Double(fillViewWidthLandscape) - fillViewRadiusLandscape + 13.0), y: frame.size.height / 2)
            contextLineView!.addArc(center: centerLineViewLandscape, radius: CGFloat(fillViewRadiusLandscape), startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
        }
        
        contextLineView!.strokePath()
    }
}
