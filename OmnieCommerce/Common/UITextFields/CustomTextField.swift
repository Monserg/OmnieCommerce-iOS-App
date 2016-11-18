//
//  CustomTextField.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

@IBDesignable class CustomTextField: UITextField {
    // MARK: - Properties
    enum Types: Int {
        case standard = 0
        case color
    }
    
    var attributedPlaceholderText: NSAttributedString!
    
    @IBInspectable var style: CGFloat = 0 {
        didSet {
            switch style {
            // color = 1
            case 1:
                self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Labels.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Labels.Colors.darkCyan!, NSKernAttributeName : 0.0])

                self.font = Config.Labels.Fonts.ubuntuLightItalic16
                self.textColor = Config.Labels.Colors.darkCyan
                self.tintColor = Config.Labels.Colors.darkCyan
                
            // standard = 0
            default:
                self.attributedPlaceholder = NSAttributedString(string: (self.placeholder?.localized())!, attributes: [NSFontAttributeName :  Config.Labels.Fonts.ubuntuLightItalic16!, NSForegroundColorAttributeName : Config.Labels.Colors.grayishBlue!, NSKernAttributeName : 0.0])

                self.font = Config.Labels.Fonts.ubuntuLightItalic16
                self.textColor = Config.Labels.Colors.grayishBlue
                self.tintColor = Config.Labels.Colors.grayishBlue
            }
            
//            self.underlined()
            let image = UIImage.dottedLine(radius: 100, space: 2, numberOfPattern: 1)
            
//            self.dashedBorderLayerWithColor(color: UIColor.red.cgColor)
            attributedPlaceholderText = self.attributedPlaceholder
        }
    }
}


// MARK: - Extensions
extension UIImage {
    
    class func dottedLine(radius: CGFloat, space: CGFloat, numberOfPattern: CGFloat) -> UIImage {
        
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: radius/2, y: radius/2))// Make(radius/2, radius/2))
        path.addLine(to: CGPoint.init(x: (numberOfPattern)*(space+1)*radius, y: radius/2))
        path.lineWidth = radius
        
        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * (space+1)]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: (numberOfPattern)*(space+1)*radius, height: radius), false, 1)
        UIColor.white.setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
        func dashedBorderLayerWithColor(color: CGColor) {
            
            let  borderLayer = CAShapeLayer()
            borderLayer.name  = "borderLayer"
            let frameSize = self.frame.size
            let shapeRect = CGRect.init(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            
            borderLayer.bounds=shapeRect
            borderLayer.position = CGPoint.init(x: frameSize.width/2, y: frameSize.height/2)
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = color
            borderLayer.lineWidth=1
            borderLayer.lineJoin=kCALineJoinRound
            borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8),NSNumber(value:4)]) as? [NSNumber]
            
            let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
            
            borderLayer.path = path.cgPath
            
//            let borderLayer1  = dashedBorderLayerWithColor(color: UIColor.black.cgColor)
            
            self.layer.addSublayer(borderLayer)
            
        }
}
