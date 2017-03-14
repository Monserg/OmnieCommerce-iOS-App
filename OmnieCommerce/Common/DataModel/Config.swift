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
import MapKit

enum ThemeDesign: String {
    case LightForUser   =   "LightForUser"
    case LightForGuest  =   "LightForGuest"
    case DarkForUser    =   "DarkForUser"
    case DarkForGuest   =   "DarkForGuest"
}

typealias HandlerSendButtonCompletion               =   (() -> ())
typealias HandlerRegisterButtonCompletion           =   (() -> ())
typealias HandlerForgotPasswordButtonCompletion     =   (() -> ())
typealias HandlerCancelButtonCompletion             =   (() -> ())
typealias HandlerNavBarLeftButtonCompletion         =   (() -> ())
typealias HandlerImagePickerControllerCompletion    =   ((_ originalImage: UIImage) -> ())
typealias HandlerPassDataCompletion                 =   ((_ data: Any) -> ())
typealias HandlerLocationCompletion                 =   ((_ organizations: [Organization]) -> ())
typealias HandlerSaveButtonCompletion               =   ((_ params: [String: String]) -> ())
typealias HandlerNewViewControllerShowCompletion    =   ((_ viewController: UIViewController) -> ())
typealias HandlerViewDismissCompletion              =   ((_ actionType: ActionType) -> ())
typealias HandlerTextFieldCompletion                =   ((_ textField: CustomTextField, _ success: Bool) -> ())
typealias HandlerTextFieldShowErrorViewCompletion   =   ((_ textField: CustomTextField, _ isShow: Bool) -> ())

//typealias ResponseAPI                               =   (success: Bool, error: String?)
//typealias NameAndPasswordCheckResult                =   (isNameCorrect: Bool, isPasswordCorrect: Bool)
typealias LocationData                              =   (placemark: CLPlacemark?, coordinate: CLLocationCoordinate2D?, address: String?)
typealias OrganizationData                          =   (name: String, rating: Int, isFavorite: Bool, city: String, street: String, logo: UIImage, location: CLLocationCoordinate2D)

var isAppThemeDark                                  =   false

let NetworkReachabilityChanged                      =   NSNotification.Name("NetworkReachabilityChanged")

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
        static let errorMessageViewHeight: CGFloat              =   14
    }
    
    enum ViewStyle: String {
        case News = "News"
        case Calendar = "Calendar"
        case Favourite = "Favourite"
        case PersonalPage = "PersonalPage"
    }
}
