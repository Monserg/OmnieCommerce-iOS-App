//
//  DottedBorderView.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class DottedBorderView: UIView {
    // MARK: - Properties
    enum BorderLineColors: CGFloat {
        case lightGray = 0.0
        case veryLightOrange = 1.0
    }
    
    @IBInspectable var colorBorderLine: CGFloat = BorderLineColors.lightGray.rawValue
    @IBInspectable var radiusBorderLine: CGFloat = 0.0
    @IBInspectable var widthBorderLine: String = "1.5"
    @IBInspectable var isRectangleBorderLine: Bool = false

    
    // MARK: - Class initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        let dottes: [CGFloat] = [0.0, 4.0]
        let dottedLinePath = UIBezierPath()
        let lineWidth = CGFloat((widthBorderLine as NSString).floatValue)
        
        if (isRectangleBorderLine) {
            // Create line path around frame as rectangle
            dottedLinePath.append(UIBezierPath(roundedRect: CGRect(x: self.frame.minX + lineWidth, y: self.frame.minY + lineWidth, width: self.frame.width - 2 * lineWidth, height: self.frame.height - 2 * lineWidth), cornerRadius: radiusBorderLine))
        } else {
            // Create line path around frame as single line
            dottedLinePath.move(to: CGPoint.init(x: self.frame.minX + lineWidth, y: self.frame.maxY - lineWidth))
            dottedLinePath.addLine(to: CGPoint.init(x: self.frame.maxX + lineWidth, y: self.frame.maxY - lineWidth))
        }
        
        dottedLinePath.lineWidth = lineWidth
        dottedLinePath.setLineDash(dottes, count: dottes.count, phase: 0.0)
        dottedLinePath.lineCapStyle = .round
        (colorBorderLine == 0.0) ? Config.Views.Colors.lightGrayAlfa20?.set() : Config.Views.Colors.veryLightOrangeAlfa60?.set()
        
        dottedLinePath.stroke()
    }
}
