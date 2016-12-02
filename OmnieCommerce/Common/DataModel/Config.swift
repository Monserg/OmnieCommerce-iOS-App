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
        static let fillViewSmallRadiusLandscape: Double         =   3126.0
        static let fillViewBigRadiusPortrait: Double            =   360.0
        static let fillViewBigRadiusLandscape: Double           =   289.0
        static let fillViewLineViewDistance: Double             =   10.0
        static let lineViewThickness: CGFloat                   =   3.0
        static let lineViewSocialButtonDistance: Double         =   3.0
        
        static let bigTopBarViewHeightCoefficient: CGFloat      =   220.0 / 667
        static let bigTopBarViewWidthCoefficient: CGFloat       =   300.0 / 667
        
        static let dropDownCellHeight: CGFloat                  =   23.0
        
        // FIXME: - DELETE AFTER TEST
        static let isUserGuest: Bool                            =   true
        static let isAppThemesLight                             =   false
    }
    
    struct Fonts {
        static let ubuntuLightVeryLightGray12                   =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.veryLightGray,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightVeryLightGray12Alpha30            =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.veryLightGrayAlpha30,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightDarkCyan12                        =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.darkCyan,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightDarkCyan12Alpha30                 =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.darkCyanAlpha30,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleNone.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightSoftOrangeUnderline12             =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.softOrange,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuLightVeryLightGrayUnderline12          =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.veryLightGray,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let ubuntuRegularVeryLightOrangeUnderline12      =   [   NSFontAttributeName             :   Fonts.ubuntuLight12!,
                                                                        NSForegroundColorAttributeName  :   UIColor.veryLightOrange,
                                                                        NSKernAttributeName             :   0.0,
                                                                        NSUnderlineStyleAttributeName   :   NSUnderlineStyle.styleSingle.rawValue
                                                                    ] as [String : Any]
        
        static let helveticaNeueCyrRoman16Kern486               =   [   NSFontAttributeName             :   Fonts.helveticaNeueCyrRoman16!,
                                                                        NSForegroundColorAttributeName  :   UIColor.veryLightGray,
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
}
