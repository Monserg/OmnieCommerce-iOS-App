//
//  DottedBorderView.swift
//  OmnieCommerce
//
//  Created by msm72 on 19.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum ViewStyle: String {
    case None                           =   "None"
    case BottomDottedLine               =   "BottomDottedLine"
    case BottomDottedLineColor          =   "BottomDottedLineColor"
    case AroundDottedRectangle          =   "AroundDottedRectangle"
    case AroundDottedRectangleColor     =   "AroundDottedRectangleColor"
}

@IBDesignable class DottedBorderView: UIView {
    // MARK: - Properties
    var style: ViewStyle! = .None {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: String = "1.5"
    @IBInspectable var viewStyle: String?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        switch style! {
        case .BottomDottedLine:
            self.drawDottedLine(withColor: false)
            
        case .BottomDottedLineColor:
            self.drawDottedLine(withColor: true)
            
        case .AroundDottedRectangle:
            self.drawDottedRectangle(withColor: false)

        case .AroundDottedRectangleColor:
            self.drawDottedRectangle(withColor: true)
            
        default:
            break
        }
    }
    
    
    // MARK: - Custom Functions
    private func drawDottedLine(withColor isColor: Bool) {
        let dottes: [CGFloat]           =   [0.0, 4.0]
        let dottedLinePath              =   UIBezierPath()
        let lineWidth                   =   CGFloat((borderWidth as NSString).floatValue)
        
        self.viewStyle                  =   (isColor) ? "BottomDottedLineColor" : "BottomDottedLine"
        
        // Create line path around frame as single line
        dottedLinePath.removeAllPoints()
        
        dottedLinePath.move(to: CGPoint.init(x: self.frame.minX + lineWidth, y: self.frame.maxY - lineWidth))
        dottedLinePath.addLine(to: CGPoint.init(x: self.frame.maxX + lineWidth, y: self.frame.maxY - lineWidth))
        
        dottedLinePath.lineWidth        =   lineWidth
        dottedLinePath.setLineDash(dottes, count: dottes.count, phase: 0.0)
        dottedLinePath.lineCapStyle     =   .round
        
        (isColor) ? ((isAppThemeDark) ? UIColor.black.set() : UIColor.veryLightOrangeAlpha60.set()) :
                    ((isAppThemeDark) ? UIColor.black.set() : UIColor.lightGrayAlpha20.set())
        
        dottedLinePath.stroke()
    }

    private func drawDottedRectangle(withColor isColor: Bool) {
        let dottes: [CGFloat]           =   [0.0, 4.0]
        let dottedLinePath              =   UIBezierPath()
        let lineWidth                   =   CGFloat((borderWidth as NSString).floatValue)
        
        self.viewStyle                  =   (isColor) ? "AroundDottedRectangleColor" : "AroundDottedRectangle"

        // Create line path around frame as rectangle
        dottedLinePath.removeAllPoints()

        dottedLinePath.append(UIBezierPath(roundedRect: CGRect(x: self.frame.minX + lineWidth,
                                                               y: self.frame.minY + lineWidth,
                                                               width: self.frame.width - 2 * (self.frame.minX + lineWidth),
                                                               height: self.frame.height - 2 * (self.frame.minY + lineWidth)), cornerRadius: cornerRadius))
        
        dottedLinePath.lineWidth        =   lineWidth
        dottedLinePath.setLineDash(dottes, count: dottes.count, phase: 0.0)
        dottedLinePath.lineCapStyle     =   .round
        
        (isColor) ? ((isAppThemeDark) ? UIColor.black.set() : UIColor.veryLightOrangeAlpha60.set()) :
                    ((isAppThemeDark) ? UIColor.black.set() : UIColor.lightGrayAlpha20.set())

        dottedLinePath.stroke()
    }
}
