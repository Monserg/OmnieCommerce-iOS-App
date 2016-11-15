//
//  Config.swift
//  OmnieCommerce
//
//  Created by msm72 on 11.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//
//  http://www.colorhexa.com/009395
//  http://iosfonts.com
//

import UIKit

struct Config {
    struct Constants {
        // Big circle radius = 1531,    fill height = 80,   line height = 93 (+13),     top view height = 96 (+3)
        static let topViewBarHeightBig: CGFloat                 =   96.0
        static let circleViewRadiusBig: Double                  =   1531.0
        static let circleViewBarHeightBig: CGFloat              =   80.0
        
        // Small cirle radius = 568,    fill height = 192,  line height = 205 (+13),    top view height = 218
        static let topViewBarHeightSmall: CGFloat               =   218.0
        static let circleViewRadiusSmall: Double                =   568.0
        static let circleViewBarHeightSmall: CGFloat            =   192.0
        
        static let topViewBarLineThickness: CGFloat             =   3.0
    }
    
    struct Themes {
        struct Fonts {
        }
        
        struct Colors {
        }
    }
    
    struct Buttons {
        struct Fonts {
            static let ubuntuLightSoftOrangeUnderline12         =   [   NSFontAttributeName             :   Labels.Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.softOrange!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]

            static let ubuntuLightVeryLightGrayUnderline12      =   [   NSFontAttributeName             :   Labels.Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightGray!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]

            static let ubuntuRegularVeryLightOrangeUnderline12  =   [   NSFontAttributeName             :   Labels.Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightGray!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]

            static let ubuntuRegular16                          =   UIFont(name: "Ubuntu-Regular", size: 16.0)
        }
        
        struct Colors {
            static let softOrange                               =   UIColor(hexString: "#d9ba68")
            static let veryLightOrange                          =   UIColor(hexString: "#ffd76c")
            static let veryLightGray                            =   UIColor(hexString: "#dedede")
            static let veryDarkGray                             =   UIColor(hexString: "#343434")
        }
    }

    struct Labels {
        struct Fonts {
            static let ubuntuLight9                             =   UIFont(name: "Ubuntu-Light", size: 9.0)
            static let ubuntuLight12                            =   UIFont(name: "Ubuntu-Light", size: 12.0)
            static let ubuntuLight16                            =   UIFont(name: "Ubuntu-Light", size: 16.0)
            static let ubuntuLightItalic12                      =   UIFont(name: "Ubuntu-LightItalic", size: 12.0)
            static let ubuntuLightItalic16                      =   UIFont(name: "Ubuntu-LightItalic", size: 16.0)
            
            static let ubuntuRegular16                          =   UIFont(name: "Ubuntu-Regular", size: 16.0)

            static let helveticaNeueCyr32                       =   UIFont(name: "helveticaNeueCyr", size: 32.0)
            static let helveticaNeueCyrThin33                   =   UIFont(name: "helveticaNeueCyr-Thin", size: 33.0)
            static let helveticaNeueCyrThin47                   =   UIFont(name: "helveticaNeueCyr-Thin", size: 47.0)
            static let helveticaNeueCyrThin51                   =   UIFont(name: "helveticaNeueCyr-Thin", size: 51.0)
            static let helveticaNeueCyrRoman16                  =   UIFont(name: "helveticaNeueCyr-Roman", size: 16.0)
            
            static let helveticaNeueCyrRoman16Kern486           =   [   NSFontAttributeName             :   Labels.Fonts.helveticaNeueCyrRoman16!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightGray!,
                                                                        NSKernAttributeName             :   4.86,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        }
        
        struct Colors {
            static let darkCyan                                 =   UIColor(hexString: "#009395")
            static let moderateRed                              =   UIColor(hexString: "#c73b3c")
            static let grayishBlue                              =   UIColor(hexString: "#d5d5d6")
            static let veryDarkGray                             =   UIColor(hexString: "#333333")
            static let veryLightGray                            =   UIColor(hexString: "#dedede")
            static let veryLightOrange                          =   UIColor(hexString: "#ffd76c")
            static let lightGrayishCyan                         =   UIColor(hexString: "#cce8e8")
        }
    }
    
    struct TextFields {
        struct Fonts {
            static let ubuntuLight12                            =   UIFont(name: "Ubuntu-Light", size: 12.0)
            static let ubuntuLightItalic16                      =   UIFont(name: "Ubuntu-LightItalic", size: 16.0)
        }
        
        struct Colors {
            static let darkCyan                                 =   UIColor(hexString: "#009395")
            static let softOrange                               =   UIColor(hexString: "#d9ba68")
            static let grayishBlue                              =   UIColor(hexString: "#d5d5d6")
            static let veryLightGray                            =   UIColor(hexString: "#dedede")
            static let veryDarkDesaturatedBlue24                =   UIColor(hexString: "#24323f")
        }
    }
    
    struct Views {
        struct Colors {
            static let darkCyan                                 =   UIColor(hexString: "#009395")
            static let veryLightOrange                          =   UIColor(hexString: "#ffd76c")

            static let veryDarkDesaturatedBlue20                =   UIColor(hexString: "#203c48")
            static let veryDarkDesaturatedBlue24                =   UIColor(hexString: "#24323f")
            static let veryDarkDesaturatedBlue2f                =   UIColor(hexString: "#2f3c49")

            static let veryDarkGrayishBlue35                    =   UIColor(hexString: "#38444e")
        }
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
