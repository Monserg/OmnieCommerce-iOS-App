//
//  UIColor+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 21.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let redColor, greenColor, blueColor: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    redColor = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    greenColor = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    blueColor = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
                    
                    return
                }
            }
        }
        
        return nil
    }
    
    public convenience init?(hexString: String, withAlpha alpha: CGFloat) {
        let redColor, greenColor, blueColor: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    redColor = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    greenColor = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    blueColor = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: redColor, green: greenColor, blue: blueColor, alpha: alpha)
                    
                    return
                }
            }
        }
        
        return nil
    }
    
    open class var darkCyan: UIColor {
        set {
            self.darkCyan = UIColor(hexString: "#009395")!
        }
        
        get {
            return UIColor(hexString: "#009395")!
        }
    }
    
    open class var softOrange: UIColor {
        set {
            self.softOrange = UIColor(hexString: "#d9ba68")!
        }
        
        get {
            return UIColor(hexString: "#d9ba68")!
        }
    }
    
    open class var softCyan: UIColor {
        set {
            self.softOrange = UIColor(hexString: "#6edadb")!
        }
        
        get {
            return UIColor(hexString: "#6edadb")!
        }
    }

    open class var grayishBlue: UIColor {
        set {
            self.grayishBlue = UIColor(hexString: "#d5d5d6")!
        }
        
        get {
            return UIColor(hexString: "#d5d5d6")!
        }
    }
    
    open class var moderateRed: UIColor {
        set {
            self.moderateRed = UIColor(hexString: "#c73b3c")!
        }
        
        get {
            return UIColor(hexString: "#c73b3c")!
        }
    }
    
    open class var veryDarkGray: UIColor {
        set {
            self.veryDarkGray = UIColor(hexString: "#333333")!
        }
        
        get {
            return UIColor(hexString: "#333333")!
        }
    }
    
    open class var veryDarkCyan: UIColor {
        set {
            self.veryDarkCyan = UIColor(hexString: "#18676f")!
        }
        
        get {
            return UIColor(hexString: "#18676f")!
        }
    }
    
    open class var veryLightGray: UIColor {
        set {
            self.veryLightGray = UIColor(hexString: "#dedede")!
        }
        
        get {
            return UIColor(hexString: "#dedede")!
        }
    }
    
    open class var veryLightGrayAlpha30: UIColor {
        set {
            self.veryLightGrayAlpha30 = UIColor(hexString: "#dedede", withAlpha: 0.3)!
        }
        
        get {
            return UIColor(hexString: "#dedede", withAlpha: 0.3)!
        }
    }
    
    open class var veryLightOrange: UIColor {
        set {
            self.veryLightOrange = UIColor(hexString: "#ffd76c")!
        }
        
        get {
            return UIColor(hexString: "#ffd76c")!
        }
    }
    
    open class var veryLightOrangeAlpha30: UIColor {
        set {
            self.veryLightOrangeAlpha30 = UIColor(hexString: "#ffd76c", withAlpha: 0.3)!
        }
        
        get {
            return UIColor(hexString: "#ffd76c", withAlpha: 0.3)!
        }
    }
    
    open class var lightGrayishCyan: UIColor {
        set {
            self.lightGrayishCyan = UIColor(hexString: "#cce8e8")!
        }
        
        get {
            return UIColor(hexString: "#cce8e8")!
        }
    }
    
    open class var veryDarkGrayishBlue38: UIColor {
        set {
            self.veryDarkGrayishBlue38 = UIColor(hexString: "#38444e")!
        }
        
        get {
            return UIColor(hexString: "#38444e")!
        }
    }
    
    open class var veryDarkGrayishBlue53: UIColor {
        set {
            self.veryDarkGrayishBlue53 = UIColor(hexString: "#535e68")!
        }
        
        get {
            return UIColor(hexString: "#535e68")!
        }
    }
    
    open class var veryDarkGrayishBlue56: UIColor {
        set {
            self.veryDarkGrayishBlue56 = UIColor(hexString: "#56606a")!
        }
        
        get {
            return UIColor(hexString: "#56606a")!
        }
    }
    
    open class var veryDarkDesaturatedBlue20: UIColor {
        set {
            self.veryDarkDesaturatedBlue20 = UIColor(hexString: "#203c48")!
        }
        
        get {
            return UIColor(hexString: "#203c48")!
        }
    }
    
    // Main background color
    open class var veryDarkDesaturatedBlue24: UIColor {
        set {
            self.veryDarkDesaturatedBlue24 = UIColor(hexString: "#24323f")!
        }
        
        get {
            return UIColor(hexString: "#24323f")!
        }
    }
    
    open class var veryDarkDesaturatedBlue2f: UIColor {
        set {
            self.veryDarkDesaturatedBlue2f = UIColor(hexString: "#2f3c49")!
        }
        
        get {
            return UIColor(hexString: "#2f3c49")!
        }
    }
    
    open class var darkCyanAlpha30: UIColor {
        set {
            self.darkCyanAlpha30 = UIColor(hexString: "#009395", withAlpha: 0.3)!
        }
        
        get {
            return UIColor(hexString: "#009395", withAlpha: 0.3)!
        }
    }
    
    open class var darkCyanAlpha70: UIColor {
        set {
            self.darkCyanAlpha70 = UIColor(hexString: "#009395", withAlpha: 0.7)!
        }
        
        get {
            return UIColor(hexString: "#009395", withAlpha: 0.7)!
        }
    }
    
    open class var lightGrayAlpha20: UIColor {
        set {
            self.lightGrayAlpha20 = UIColor(hexString: "#cacaca", withAlpha: 0.2)!
        }
        
        get {
            return UIColor(hexString: "#cacaca", withAlpha: 0.2)!
        }
    }
    
    open class var lightGrayishCyanAlpha30: UIColor {
        set {
            self.lightGrayishCyan = UIColor(hexString: "#cce8e8", withAlpha: 0.3)!
        }
        
        get {
            return UIColor(hexString: "#cce8e8", withAlpha: 0.3)!
        }
    }
    
    open class var veryLightOrangeAlpha60: UIColor {
        set {
            self.veryLightOrangeAlpha60 = UIColor(hexString: "#ffd76c", withAlpha: 0.6)!
        }
        
        get {
            return UIColor(hexString: "#ffd76c", withAlpha: 0.6)!
        }
    }
    
    open class var veryDarkDesaturatedBlue25Alpha1: UIColor {
        set {
            self.veryDarkDesaturatedBlue25Alpha1 = UIColor(hexString: "#253340", withAlpha: 1.0)!
        }
        
        get {
            return UIColor(hexString: "#253340", withAlpha: 1.0)!
        }
    }
    
    open class var veryDarkDesaturatedBlue25Alpha94: UIColor {
        set {
            self.veryDarkDesaturatedBlue25Alpha94 = UIColor(hexString: "#253340", withAlpha: 0.94)!
        }
        
        get {
            return UIColor(hexString: "#253340", withAlpha: 0.94)!
        }
    }
}
