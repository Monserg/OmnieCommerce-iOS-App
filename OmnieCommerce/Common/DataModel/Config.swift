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
        static let fillViewSmallRadiusPortrait: Double          =   1531.0
        static let fillViewSmallRadiusLandscape: Double         =   5726.0
        static let fillViewBigRadiusPortrait: Double            =   360.0
        static let fillViewBigRadiusLandscape: Double           =   289.0
        static let fillViewLineViewDistance: Double             =   10.0
        static let lineViewThickness: CGFloat                   =   3.0
        static let lineViewSocialButtonDistance: Double         =   3.0
        
        static let smallTopBarViewHeightCoefficientPortraitt    =   CGFloat(75.0 / 667)
        static let smallTopBarViewHeightCoefficientLandscape    =   CGFloat(80.0 / 667)
        static let bigTopBarViewHeightCoefficient: CGFloat      =   220.0 / 667
        static let bigTopBarViewWidthCoefficient: CGFloat       =   300.0 / 667
        
        
        // FIXME: - DELETE AFTER TEST
        static let isUserGuest: Bool                            =   false
        static let isAppThemesLight                             =   false
    }
    
    struct Fonts {
        static let ubuntuLightSoftOrangeUnderline12             =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.softOrange!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightVeryLightGrayUnderline12          =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightGray!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuRegularVeryLightOrangeUnderline12      =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightOrange!,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let helveticaNeueCyrRoman16Kern486               =   [   NSFontAttributeName             :   Fonts.helveticaNeueCyrRoman16!,
                                                                        NSForegroundColorAttributeName  :   Colors.veryLightGray!,
                                                                        NSKernAttributeName             :   4.86,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLight9                                 =   UIFont(name: "Ubuntu-Light", size: 9.0)
        static let ubuntuLight12                                =   UIFont(name: "Ubuntu-Light", size: 12.0)
        static let ubuntuLight16                                =   UIFont(name: "Ubuntu-Light", size: 16.0)
        static let ubuntuLightItalic10                          =   UIFont(name: "Ubuntu-LightItalic", size: 10.0)
        static let ubuntuLightItalic12                          =   UIFont(name: "Ubuntu-LightItalic", size: 12.0)
        static let ubuntuLightItalic16                          =   UIFont(name: "Ubuntu-LightItalic", size: 16.0)
        
        static let ubuntuRegular16                              =   UIFont(name: "Ubuntu-Regular", size: 16.0)
        
        static let helveticaNeueCyrLight32                      =   UIFont(name: "helveticaNeueCyr-Light", size: 32.0)
        static let helveticaNeueCyrThin21                       =   UIFont(name: "helveticaNeueCyr-Thin", size: 21.0)
        static let helveticaNeueCyrThin33                       =   UIFont(name: "helveticaNeueCyr-Thin", size: 33.0)
        static let helveticaNeueCyrThin47                       =   UIFont(name: "helveticaNeueCyr-Thin", size: 47.0)
        static let helveticaNeueCyrThin51                       =   UIFont(name: "helveticaNeueCyr-Thin", size: 51.0)
        static let helveticaNeueCyrRoman16                      =   UIFont(name: "helveticaNeueCyr-Roman", size: 16.0)
        
    }
    
    struct Colors {
        static let darkCyan                                     =   UIColor(hexString: "#009395")
        static let softOrange                                   =   UIColor(hexString: "#d9ba68")
        static let grayishBlue                                  =   UIColor(hexString: "#d5d5d6")
        static let moderateRed                                  =   UIColor(hexString: "#c73b3c")
        static let veryDarkGray                                 =   UIColor(hexString: "#333333")
        static let veryDarkCyan                                 =   UIColor(hexString: "#18676f")
        static let veryLightGray                                =   UIColor(hexString: "#dedede")
        static let veryLightOrange                              =   UIColor(hexString: "#ffd76c")
        static let lightGrayishCyan                             =   UIColor(hexString: "#cce8e8")
        static let veryDarkGrayishBlue38                        =   UIColor(hexString: "#38444e")
        static let veryDarkDesaturatedBlue20                    =   UIColor(hexString: "#203c48")
        static let veryDarkDesaturatedBlue24                    =   UIColor(hexString: "#24323f")
        static let veryDarkDesaturatedBlue2f                    =   UIColor(hexString: "#2f3c49")
        
        static let lightGrayAlfa20                              =   UIColor(hexString: "#cacaca", withAlpha: 0.2)
        static let veryLightOrangeAlfa60                        =   UIColor(hexString: "#ffd76c", withAlpha: 0.6)
        static let veryDarkDesaturatedBlue25Alfa1               =   UIColor(hexString: "#253340", withAlpha: 1.0)
        static let veryDarkDesaturatedBlue25Alfa94              =   UIColor(hexString: "#253340", withAlpha: 0.94)
    }
}
