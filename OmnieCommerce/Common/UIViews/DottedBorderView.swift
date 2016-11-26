//
//  DottedBorderView.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum ViewStyle: String {
    case BottomDottedLine = "BottomDottedLine"
    case BottomDottedLineColor = "BottomDottedLineColor"
    case AroundDottedRectangle = "AroundDottedRectangle"
    case AroundDottedRectangleColor = "AroundDottedRectangleColor"
}

@IBDesignable class DottedBorderView: UIView {
    // MARK: - Properties
    @IBInspectable var borderWidth: String = "1.5"
    @IBInspectable var viewStyle: String?
//        {
//        didSet { setupWithStyleNamed(viewStyle) }
//        //        get { return nil }
//    }
//    
//    func setupWithStyleNamed(_ named: String?) {
//        if let styleName = named, let viewStyle = ViewStyle(rawValue: styleName) {
//            setupWithStyle(viewStyle)
//        }
//    }
//    
//    func setupWithStyle(_ viewStyle: ViewStyle) {
//        switch viewStyle {
//        case .BottomDottedLine:
//            cornerRadius = 0.0
//            borderWidth = 1.5
//            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.lightGrayAlfa20
//            
//        case .BottomDottedLineColor:
//            cornerRadius = 0.0
//            borderWidth = 3
//            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.veryLightOrangeAlfa60
//            
//        case .AroundDottedRectangle:
//            cornerRadius = 10.0
//            borderWidth = 1.5
//            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.lightGrayAlfa20
//            
//        case .AroundDottedRectangleColor:
//            cornerRadius = 10.0
//            borderWidth = 1.5
//            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.veryLightOrangeAlfa60
//        }
//    }
    
    
    // MARK: - Class Initialization
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
        let lineWidth = CGFloat((borderWidth as NSString).floatValue)
        
        if (viewStyle?.hasSuffix("Rectangle"))! {
            // Create line path around frame as rectangle
            dottedLinePath.append(UIBezierPath(roundedRect: CGRect(x: self.frame.minX + lineWidth, y: self.frame.minY + lineWidth, width: self.frame.width - 2 * lineWidth, height: self.frame.height - 2 * lineWidth), cornerRadius: cornerRadius))
        } else {
            // Create line path around frame as single line
            dottedLinePath.move(to: CGPoint.init(x: self.frame.minX + lineWidth, y: self.frame.maxY - lineWidth))
            dottedLinePath.addLine(to: CGPoint.init(x: self.frame.maxX + lineWidth, y: self.frame.maxY - lineWidth))
        }
        
        dottedLinePath.lineWidth = lineWidth
        dottedLinePath.setLineDash(dottes, count: dottes.count, phase: 0.0)
        dottedLinePath.lineCapStyle = .round
        
        if (viewStyle?.hasSuffix("Color"))! {
            (Config.Constants.isAppThemesLight) ? UIColor.black.set() : Config.Colors.veryLightOrangeAlfa60?.set()
        } else {
            (Config.Constants.isAppThemesLight) ? UIColor.black.set() : Config.Colors.lightGrayAlfa20?.set()
        }
        
        dottedLinePath.stroke()
    }
}
