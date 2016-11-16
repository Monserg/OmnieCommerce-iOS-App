//
//  CircleView.swift
//  OmnieCommerce
//
//  Created by msm72 on 16.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

class CircleView: UIView {
    // MARK: - Properties
    // Small cirle radius = 568, fill height = 192, line height = 205, top view height = 218
    // Big circle radius = 1531, fill height = 80, line height = 93 (+13), top view height = 96 (+3)
    enum CirleRadius {
        case small
        case big
    }
    
    var cirleRadius = CirleRadius.big {
        didSet {
            print(cirleRadius)
        }
    }
        
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        let contextFill = UIGraphicsGetCurrentContext()
        let contextLine = UIGraphicsGetCurrentContext()
        
        // Set the circle outerline-colour
        Config.Views.Colors.darkCyan?.set()
        let contextHeight = (cirleRadius == .small) ? Config.Constants.circleViewBarHeightSmall : Config.Constants.circleViewBarHeightBig
        let circleRadius = (cirleRadius == .small) ? CGFloat(Config.Constants.circleViewRadiusSmall) : CGFloat(Config.Constants.circleViewRadiusBig)
        
        
        // Create Fill Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            contextFill!.addArc(center: CGPoint(x: frame.size.width/2, y: contextHeight - circleRadius), radius: circleRadius, startAngle: (rect.size.width - 10)/2, endAngle: 0, clockwise: true)
        } else {
            contextFill!.addArc(center: CGPoint(x: contextHeight - circleRadius, y: frame.size.height/2), radius: circleRadius, startAngle: (rect.size.width - 10)/2, endAngle: 0, clockwise: true)
        }
        
        contextFill!.fillPath()
        
        // Set the circle outerline-width
        contextLine!.setLineWidth(Config.Constants.topViewBarLineThickness)
        
        // Set the circle outerline-colour
        Config.Views.Colors.veryDarkGrayishBlue35?.set()
        
        // Create Line Circle
        if UIApplication.shared.statusBarOrientation.isPortrait {
            contextLine!.addArc(center: CGPoint(x: frame.size.width/2, y: contextHeight + 13 - circleRadius), radius: circleRadius, startAngle: (rect.size.width - 10)/2, endAngle: 0, clockwise: true)
        } else {
            contextLine!.addArc(center: CGPoint(x: contextHeight + 13 - circleRadius, y: frame.size.height/2), radius: circleRadius, startAngle: (rect.size.width - 10)/2, endAngle: 0, clockwise: true)
        }
        
        contextLine!.strokePath()
    }
}
