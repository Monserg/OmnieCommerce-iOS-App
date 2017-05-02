//
//  CustomView.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {
    // MARK: - Properties
    enum StyleView: String {
        case Fill           =   "Fill"
        case Border         =   "Border"
        case LeftCircle     =   "LeftCircle"
    }
    
    var values: [Any]?

    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?

    @IBInspectable var circleRadius: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var circleFillColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var circleLineColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var style: String? {
        didSet {
            let styleCase = StyleView.init(rawValue: style!)!
            
            switch styleCase {
            case .Fill:
                layer.cornerRadius      =   frame.width / 2
                layer.backgroundColor   =   UIColor.darkCyan.cgColor
                clipsToBounds           =   true
                
            case .Border:
                layer.cornerRadius      =   bounds.width / 2
                layer.borderColor       =   UIColor.darkCyan.cgColor
                layer.borderWidth       =   1
                clipsToBounds           =   true
                
            case .LeftCircle:
                setNeedsDisplay()
            }
        }
    }

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        guard circleRadius != 0, circleFillColor != nil, circleLineColor != nil else {
            return
        }

        if style == "LeftCircle" {
            // Get the Graphics Context
            let contextFillView     =   UIGraphicsGetCurrentContext()
            let contextLineView     =   UIGraphicsGetCurrentContext()
            
            // Draw circle fill view: set color
            circleFillColor!.set()
            
            // Draw circle fill view: create circle
            let centerFillView      =   CGPoint(x: rect.width - CGFloat(Config.Constants.fillViewLineViewDistance) - circleRadius, y: rect.height / 2)
            contextFillView!.addArc(center: centerFillView, radius: circleRadius, startAngle: (rect.width - 10) / 2, endAngle: 0, clockwise: true)
            contextFillView!.fillPath()
            
            // Draw circle line view: set width
            contextLineView!.setLineWidth(Config.Constants.lineViewThickness)
            
            // Draw circle line view: set color
            circleLineColor!.set()
            
            // Draw circle line view: create line
            let centerLineView      =   CGPoint(x: rect.width - circleRadius - Config.Constants.lineViewThickness, y: rect.height / 2)
            contextLineView!.addArc(center: centerLineView, radius: circleRadius, startAngle: (rect.width - 10) / 2, endAngle: 0, clockwise: true)
            contextLineView!.strokePath()
        }
    }
}
