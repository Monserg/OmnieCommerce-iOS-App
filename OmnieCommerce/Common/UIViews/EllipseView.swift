//
//  EllipseView.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class EllipseView: UIView {
    // MARK: - Properties
    @IBInspectable var fillWidth: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var radius: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

  
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
        
        guard fillWidth != 0.0 && lineWidth != 0.0 && radius != 0.0 else {
            return
        }
        
        // Get the Graphics Context
        let contextFillView = UIGraphicsGetCurrentContext()
        let contextLineView = UIGraphicsGetCurrentContext()
        
        // Set the circle outerline-colour
        UIColor.init(hexString: "#009395", withAlpha: 1.0)!.set()
        
        // Create Fill Ellipse
        let centerFillEllipseView = CGPoint(x: fillWidth - radius, y: frame.size.height / 2)
            
        contextFillView!.addArc(center: centerFillEllipseView, radius: radius, startAngle: rect.size.width / 2, endAngle: 0, clockwise: true)
        contextFillView!.fillPath()

        // Set the circle outerline-width
        contextLineView!.setLineWidth(Config.Constants.lineViewThickness)
        
        // Set the circle outerline-colour
        UIColor.init(hexString: "#2f3c49", withAlpha: 1.0)!.set()
        
        // Create Line Circle
        let centerLineViewLandscape = CGPoint(x: lineWidth - radius - Config.Constants.lineViewThickness, y: frame.size.height / 2)
            
        contextLineView!.addArc(center: centerLineViewLandscape, radius: radius, startAngle: rect.size.width / 2, endAngle: 0, clockwise: true)
        contextLineView!.strokePath()
    }
}
