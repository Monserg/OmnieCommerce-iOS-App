//
//  Config.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

struct Config {
    struct Theme {
        // Background color
        static let debugBackground = UIColor.purple
        
        // Button colors
        static let buttonDisabled       =   UIColor(hexString: "#ffe700ff")
        static let buttonNormal         =   UIColor(hexString: "#ffe700ff")
        static let buttonSelected       =   UIColor(hexString: "#ffe700ff")
        static let backgroundPattern    =   UIColor(hexString: "#ffe700ff")
    }
    
    struct Colors {
        static let topView = UIColor(hexString: "#009395")
        
    }
    
    struct Fonts {
        static let defaultFont = UIFont(name: "ProximaNova-Regular", size:18.0)
        static let navBarFont  = UIFont(name: "ProximaNova-Regular", size:16.0)
    }
}


// MARK: - UIColor extensions
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
}
