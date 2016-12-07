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
        static let isUserGuest: Bool                            =   false
        static let isAppThemesLight                             =   false
    }
    
    enum ViewStyle: String {
        case News = "News"
        case Calendar = "Calendar"
        case Favourite = "Favourite"
        case PersonalPage = "PersonalPage"
    }
}
