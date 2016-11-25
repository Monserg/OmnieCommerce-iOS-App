//
//  CircleView.swift
//  OmnieCommerce
//
//  Created by msm72 on 16.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {
    // MARK: - Properties
    // Small cirle radius = 568, fill height = 192, line height = 205, top view height = 218
    // Big circle radius = 1531, fill height = 80, line height = 93 (+13), top view height = 96 (+3)
    enum CirleRadiusStyle: String {
        case Big = "Big"
        case Small = "Small"
    }

    @IBInspectable var cirleRadiusStyle = String() {
        didSet {
            print(cirleRadiusStyle)
        }
    }
        
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
//        // Get the Graphics Context
//        let contextFill = UIGraphicsGetCurrentContext()
//        let contextLine = UIGraphicsGetCurrentContext()
//        
//        // Set the circle outerline-colour
//        Config.Colors.darkCyan?.set()
        
//        if let viewStyle = CirleRadiusStyle(rawValue: cirleRadiusStyle) {
//            let contextHeight = (viewStyle == .Small) ? Config.Constants.circleViewBarHeightSmall : Config.Constants.circleViewBarHeightBig
//            let circleRadiusValue = (viewStyle == .Small) ? CGFloat(Config.Constants.circleViewRadiusSmall) : (UIApplication.shared.statusBarOrientation.isPortrait) ? CGFloat(Config.Constants.circleViewRadiusPortraitBig) : CGFloat(Config.Constants.circleViewRadiusLandscapeBig)
//            
//            // Create Fill Circle
//            if UIApplication.shared.statusBarOrientation.isPortrait {
//                let centerPortrait = CGPoint(x: frame.size.width / 2, y: contextHeight - circleRadiusValue)
//                
//                contextFill!.addArc(center: centerPortrait, radius: circleRadiusValue, startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
//            } else {
//                let centerLandscape = (viewStyle == .Big) ? CGPoint(x: frame.size.width / 2, y: contextHeight - circleRadiusValue) : CGPoint(x: contextHeight - circleRadiusValue, y: frame.size.height / 2)
//                
//                contextFill!.addArc(center: centerLandscape, radius: circleRadiusValue, startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
//            }
//            
//            contextFill!.fillPath()
//            
//            // Set the circle outerline-width
//            contextLine!.setLineWidth(Config.Constants.topViewBarLineThickness)
//            
//            // Set the circle outerline-colour
//            Config.Colors.veryDarkGrayishBlue38?.set()
//            
//            // Create Line Circle
//            if UIApplication.shared.statusBarOrientation.isPortrait {
//                let centerPortrait = CGPoint(x: frame.size.width / 2, y: contextHeight + 13 - circleRadiusValue)
//                
//                contextLine!.addArc(center: centerPortrait, radius: circleRadiusValue, startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
//            } else {
//                let centerLandscape = (viewStyle == .Big) ? CGPoint(x: frame.size.width / 2, y: contextHeight + 13 - circleRadiusValue) : CGPoint(x: contextHeight + 13 - circleRadiusValue, y: frame.size.height / 2)
//                
//                contextLine!.addArc(center: centerLandscape, radius: circleRadiusValue, startAngle: (rect.size.width - 10) / 2, endAngle: 0, clockwise: true)
//            }
//            
//            contextLine!.strokePath()
//        }
    }
}
