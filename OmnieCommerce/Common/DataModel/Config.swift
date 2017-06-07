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
import AFNetworking

enum ThemeDesign: String {
    case LightForUser   =   "LightForUser"
    case LightForGuest  =   "LightForGuest"
    case DarkForUser    =   "DarkForUser"
    case DarkForGuest   =   "DarkForGuest"
}

// Keys
public let keyEmail: String                         =   "email"
public let keyResetToken: String                    =   "resetToken"
public let keyPassword: String                      =   "password"
public let keyAccessToken: String                   =   "accessToken"
public let keyCategories: String                    =   "Categories"
public let keyOrganization: String                  =   "Organization"
public let keyOrganizations: String                 =   "Organizations"
public let keyFavoriteOrganizations: String         =   "FavoriteOrganizations"
public let keyService: String                       =   "Service"
public let keyServices: String                      =   "Services"
public let keyOrder: String                         =   "Order"
public let keyOrders: String                        =   "Orders"
public let keyFavoriteServices: String              =   "FavoriteServices"
public let keyNewsData: String                      =   "News"
public let keyNewsActions: String                   =   "Actions"
public let keyHandbook: String                      =   "Handbook"
public let keyHandbooks: String                     =   "Handbooks"
public let keyDiscountCard: String                  =   "DiscountCard"
public let keyDiscountCards: String                 =   "DiscountCards"
public let keyBusinessCard: String                  =   "BusinessCard"
public let keyBusinessCards: String                 =   "BusinessCards"


// Handlers
typealias HandlerSendButtonCompletion               =   (() -> ())
typealias HandlerRegisterButtonCompletion           =   (() -> ())
typealias HandlerForgotPasswordButtonCompletion     =   (() -> ())
typealias HandlerCancelButtonCompletion             =   (() -> ())
typealias HandlerNavBarLeftButtonCompletion         =   (() -> ())
typealias HandlerImagePickerControllerCompletion    =   ((_ originalImage: UIImage) -> ())
typealias HandlerPassDataCompletion                 =   ((_ data: Any?) -> ())
typealias HandlerLocationCompletion                 =   ((_ organizations: [Organization]) -> ())
typealias HandlerSaveButtonCompletion               =   ((_ params: [String: Any]) -> ())
typealias HandlerNewViewControllerShowCompletion    =   ((_ viewController: UIViewController) -> ())
typealias HandlerViewDismissCompletion              =   ((_ actionType: ActionType) -> ())
typealias HandlerTextFieldCompletion                =   ((_ textField: CustomTextField, _ success: Bool) -> ())
typealias HandlerTextFieldShowErrorViewCompletion   =   ((_ textField: CustomTextField, _ isShow: Bool) -> ())


// New Types
typealias Period                                    =   (datesPeriod: DatesPeriod, timesPeriod: TimesPeriod)
typealias DatesPeriod                               =   (dateStart: Date, dateEnd: Date)
typealias TimesPeriod                               =   (hourStart: Int, minuteStart: Int, hourEnd: Int, minuteEnd: Int)
typealias LocationData                              =   (placemark: CLPlacemark?, coordinate: CLLocationCoordinate2D?, address: String?)
typealias OrganizationData                          =   (name: String, rating: Int, isFavorite: Bool, city: String, street: String, logo: UIImage, location: CLLocationCoordinate2D)
typealias OrderPrepare                              =   (organizationName: String, serviceName: String, additionalServices: String, period: Period, comment: String)


// Public Constants
let NetworkReachabilityChanged                      =   NSNotification.Name("NetworkReachabilityChanged")

var appUser: AppUser {
    set { }
    
    get {
        return CoreDataManager.instance.entityBy("AppUser", andCodeID: "AppUser") as! AppUser
    }
}

var appSettings: AppSettings {
    set { }
    
    get {
        return CoreDataManager.instance.entityBy("AppSettings", andCodeID: "AppSettings") as! AppSettings
    }
}

var isLightColorAppSchema: Bool {
    set { }
    
    get {
        return appSettings.lightColorSchema
    }
}

var isNetworkAvailable: Bool {
    set { }
    
    get {
        print("ZZZ = \(AFNetworkReachabilityManager.shared().isReachable)")
        return AFNetworkReachabilityManager.shared().isReachable
    }
}


// Public Constans as Struct's
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
        static let paginationLimit: Int                         =   2
        
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
