//
//  MSMRestApiManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias RequestParametersType = (method: HTTPMethod, apiStringURL: String, body: [String: Any]?, bodyType: BodyType, headers: [String: String]?, parameters: [String: Any]?)

enum RequestType {
    // Security
    case userCheckEmail([String: Any], Bool)                // Forgot password. Step 2
    case userRegistration([String: Any], Bool)
    case userAutorization([String: Any], Bool)
    case userForgotPassword([String: Any], Bool)            // Forgot password. Step 1
    case userChangePasswordFromLogin([String: Any], Bool)   // Forgot password. Step 3
    
    
    // Categories
    case userGetCategoriesList([String: Any], Bool)
    
    
    // Handbook
    case userGetHandbooksList([String: Any], Bool)
    case userCreateNewHandbook([String: Any], Bool)
    
    
    // Order
    case userMakeNewOrder([String: Any], Bool)
    case userGetOrderByID([String: Any], Bool)
    case userGetOrdersList([String: Any], Bool)
    case userCancelOrderByID([String: Any], Bool)
    case userGetOrderTimeSheetForDay([String: Any], Bool)
    case userGetOrderPriceWithoutDiscount([String: Any], Bool)
    
    
    // Review
    case userAddServiceReview([String: Any], Bool)
    
    
    // Organization
    case userGetOrganizationByID([String: Any], Bool)
    case userGetOrganizationsListByName([String: Any], Bool)
    case userGetFavoriteOrganizationsList([String: Any], Bool)
    case userAddRemoveFavoriteOrganization([String: Any], Bool)
    case userGetOrganizationsListByCategory([String: Any], Bool)
    case userGetOrganizationsListBySubcategory([String: Any], Bool)
    
    
    // Service
    case userGetServiceByID([String: Any], Bool)
    case userGetServicesListByName([String: Any], Bool)
    case userGetFavoriteServicesList([String: Any], Bool)
    case userAddRemoveFavoriteService([String: Any], Bool)
    case userGetServicesListByCategory([String: Any], Bool)
    case userGetServicesListBySubcategory([String: Any], Bool)
    
    
    
    // News
    case userGetActionByID([String: Any], Bool)
    case userGetActionsList([String: Any], Bool)
    case userGetNewsDataByID([String: Any], Bool)
    case userGetNewsDataList([String: Any], Bool)
    
    
    // Profile
    case userDeleteImage([String: Any]?, Bool)
    case userChangeEmail([String: Any], Bool)
    case userGetProfileData([String: Any]?, Bool)
    case userUploadProfileData([String: Any], Bool)
    case userGetProfileSettings([String: Any]?, Bool)
    case userUploadProfileSettings([String: Any], Bool)
    case userChangePasswordFromProfile([String: Any], Bool)
    
    
    func introduced() -> RequestParametersType {
        let headers = [ "Content-Type": "application/json" ]
        let userAccessToken = (CoreDataManager.instance.entityDidLoad(byName: "AppUser", andPredicateParameters: nil) as! AppUser).accessToken
        var headersExtended = (userAccessToken != nil) ? [ "Content-Type": "application/json", "Authorization": userAccessToken! ] : nil
        
        // Body & Parametes named such as in Postman
        switch self {
            // Security
        // Forgot password, step 2
        case .userCheckEmail(let params, let isBodyParams):     return (method: .post,
                                                                        apiStringURL: "/forgot/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headers,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userRegistration(let params, let isBodyParams):   return (method: .post,
                                                                        apiStringURL: "/registration/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headers,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userAutorization(let params, let isBodyParams):   return (method: .post,
                                                                        apiStringURL: "/auth/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headers,
                                                                        parameters: (isBodyParams ? nil : params))
            
        // Forgot password. Step 1
        case .userForgotPassword(let params, let isBodyParams):     return (method: .get,
                                                                            apiStringURL: "/forgot/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .Default,
                                                                            headers: headers,
                                                                            parameters: (isBodyParams ? nil : params))
            
        // Forgot password. Step 3
        case .userChangePasswordFromLogin(let params, let isBodyParams):    return (method: .get,
                                                                                    apiStringURL: "/change-password/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .Default,
                                                                                    headers: headers,
                                                                                    parameters: (isBodyParams ? nil : params))
            
            
        // Categories
        case .userGetCategoriesList(let params, let isBodyParams):  return (method: .get,
                                                                            apiStringURL: "/categories/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headers,
                                                                            parameters: (isBodyParams ? nil : params))
            
        // Handbook
        case .userGetHandbooksList(let params, let isBodyParams):  return (method: .get,
                                                                            apiStringURL: "/user/handbook/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))

        case .userCreateNewHandbook(let params, let isBodyParams):  return (method: .post,
                                                                            apiStringURL: "/user/handbook/create/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
            
        // Order
        case .userMakeNewOrder(let params, let isBodyParams):   return (method: .put,
                                                                        apiStringURL: "/user/order/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .ItemsDictionary,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetOrderByID(let params, let isBodyParams):   return (method: .get,
                                                                        apiStringURL: "/user/order/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .ItemsDictionary,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetOrdersList(let params, let isBodyParams):  return (method: .post,
                                                                        apiStringURL: "/user/order/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .ItemsArray,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userCancelOrderByID(let params, let isBodyParams):    return (method: .get,
                                                                            apiStringURL: "/user/order/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetOrderTimeSheetForDay(let params, let isBodyParams):    return (method: .get,
                                                                                    apiStringURL: "/user/order/timesheet/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsDictionary,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userGetOrderPriceWithoutDiscount(let params, let isBodyParams):   return (method: .post,
                                                                                        apiStringURL: "/user/order/price/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .Default,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
            
        // Review
        case .userAddServiceReview(let params, let isBodyParams):   return (method: .put,
                                                                            apiStringURL: "/user/review/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))

            
        // Organization
        case .userGetOrganizationByID(let params, let isBodyParams):    return (method: .get,
                                                                                apiStringURL: "/user/organization/",
                                                                                body: (isBodyParams ? params : nil),
                                                                                bodyType: .ItemsDictionary,
                                                                                headers: headersExtended,
                                                                                parameters: (isBodyParams ? nil : params))
            
        case .userGetOrganizationsListByName(let params, let isBodyParams):     return (method: .post,
                                                                                        apiStringURL: "/user/organization/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .ItemsArray,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetFavoriteOrganizationsList(let params, let isBodyParams):   return (method: .post,
                                                                                        apiStringURL: "/user/organization/favorite/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .ItemsArray,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userAddRemoveFavoriteOrganization(let params, let isBodyParams):  return (method: .put,
                                                                                        apiStringURL: "/user/organization/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .Default,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetOrganizationsListByCategory(let params, let isBodyParams):     return (method: .post,
                                                                                            apiStringURL: "/user/organization/",
                                                                                            body: (isBodyParams ? params : nil),
                                                                                            bodyType: .ItemsArray,
                                                                                            headers: headersExtended,
                                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetOrganizationsListBySubcategory(let params, let isBodyParams):  return (method: .post,
                                                                                            apiStringURL: "/user/organization/",
                                                                                            body: (isBodyParams ? params : nil),
                                                                                            bodyType: .ItemsArray,
                                                                                            headers: headersExtended,
                                                                                            parameters: (isBodyParams ? nil : params))
            
            
        // Service
        case .userGetServiceByID(let params, let isBodyParams):     return (method: .get,
                                                                            apiStringURL: "/user/service/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetServicesListByName(let params, let isBodyParams):      return (method: .post,
                                                                                    apiStringURL: "/user/service/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsArray,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userGetFavoriteServicesList(let params, let isBodyParams):    return (method: .post,
                                                                                    apiStringURL: "/user/service/favorite/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsArray,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userAddRemoveFavoriteService(let params, let isBodyParams):   return (method: .put,
                                                                                    apiStringURL: "/user/service/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .Default,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userGetServicesListByCategory(let params, let isBodyParams):  return (method: .post,
                                                                                    apiStringURL: "/user/service/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsArray,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userGetServicesListBySubcategory(let params, let isBodyParams):   return (method: .post,
                                                                                        apiStringURL: "/user/service/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .ItemsArray,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
            
        // News
        case .userGetActionByID(let params, let isBodyParams):  return (method: .get,
                                                                        apiStringURL: "/user/promotion/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .ItemsDictionary,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
            
            
        case .userGetActionsList(let params, let isBodyParams):     return (method: .post,
                                                                            apiStringURL: "/user/promotion/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetNewsDataByID(let params, let isBodyParams):    return (method: .get,
                                                                            apiStringURL: "/user/news/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetNewsDataList(let params, let isBodyParams):    return (method: .post,
                                                                            apiStringURL: "/user/news/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
            
        // Profile
        case .userDeleteImage(let params, let isBodyParams):    return (method: .delete,
                                                                        apiStringURL: "/user/profile/image/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userChangeEmail(let params, let isBodyParams):    return (method: .get,
                                                                        apiStringURL: "/user/email/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headersExtended,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetProfileData(let params, let isBodyParams):     return (method: .get,
                                                                            apiStringURL: "/user/profile/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsDictionary,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userUploadProfileData(let params, let isBodyParams):
            headersExtended!["Role"] = "admin"
            
            return (method: .post,
                    apiStringURL: "/user/profile/",
                    body: (isBodyParams ? params : nil),
                    bodyType: .ItemsDictionary,
                    headers: headersExtended!,
                    parameters: (isBodyParams ? nil : params))
            
        case .userGetProfileSettings(let params, let isBodyParams):     return (method: .get,
                                                                                apiStringURL: "/user/config/",
                                                                                body: (isBodyParams ? params : nil),
                                                                                bodyType: .ItemsDictionary,
                                                                                headers: headersExtended,
                                                                                parameters: (isBodyParams ? nil : params))
            
        case .userUploadProfileSettings(let params, let isBodyParams):  return (method: .post,
                                                                                apiStringURL: "/user/config/",
                                                                                body: (isBodyParams ? params : nil),
                                                                                bodyType: .Default,
                                                                                headers: headersExtended,
                                                                                parameters: (isBodyParams ? nil : params))
            
        case .userChangePasswordFromProfile(let params, let isBodyParams):      return (method: .put,
                                                                                        apiStringURL: "/user/password/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .Default,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
        }
    }
}

final class MSMRestApiManager {
    // MARK: - Properties
    static let instance = MSMRestApiManager()
    
    var appURL: URL!
    let appHostURL = URL.init(string: "http://omniecom.com:9009")!
    let imageHostURL = URL.init(string: "http://omniecom.com:9000/omnie/api/image/v1")!
    let appApiVersionString = "api/v1/omnie/webservice"
    var headers = ["Content-Type": "application/json"]
    
    var appApiString: String! {
        didSet {
            appURL = (appHostURL.appendingPathComponent(appApiVersionString)).appendingPathComponent(appApiString)
        }
    }
    
    // MARK: - Class Initialization
    private init() { }
    
    
    // MARK: - Class Functions
    
    // Main Generic func
    func userRequestDidRun(_ requestType: RequestType, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let requestParameters = requestType.introduced()
        appApiString = requestParameters.apiStringURL
        
        if (requestParameters.parameters != nil) {
            for (index, dictionary) in requestParameters.parameters!.enumerated() {
                let key = dictionary.key
                let value = dictionary.value
                
                if (index) == 0 {
                    appURL = URL.init(string: appURL.absoluteString.appending("?\(key)=\(value)"))
                } else {
                    appURL = URL.init(string: appURL.absoluteString.appending("&\(key)=\(value)"))
                }
            }
        }
        
        Alamofire.request(appURL, method: requestParameters.method, parameters: requestParameters.body, encoding: JSONEncoding.default, headers: requestParameters.headers).responseJSON { dataResponse -> Void in
            guard dataResponse.error == nil && dataResponse.result.value != nil else {
                handlerResponseAPICompletion(nil)
                return
            }
            
            var responseAPI: ResponseAPI!
            let json = JSON(dataResponse.result.value!)
            responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: requestParameters.bodyType)
            
            // Save headers
            if (dataResponse.response?.statusCode == 200 && requestParameters.bodyType == .Default) {
                let responseHeaders = dataResponse.response!.allHeaderFields
                UserDefaults.standard.set(responseHeaders["Authorization"] as? String, forKey: keyAccessToken)
            }
            
            handlerResponseAPICompletion(responseAPI)
            return
        }
    }
    
    // User upload image
    func userUploadImage(_ image: UIImage, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let imageData = UIImagePNGRepresentation(image)
        appURL = appApiString.convertToURL(withSize: .Original, inMode: .Upload)
        let uploadURL = try! URLRequest(url: appURL, method: .post, headers: headers)
        
        guard imageData != nil else {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "picture", fileName: "userImage.jpg", mimeType: "image/jpeg")
        }, with: uploadURL, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { dataResponse in
                    debugPrint(dataResponse)
                    
                    let json = JSON(dataResponse.result.value!)
                    let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                    
                    handlerResponseAPICompletion(responseAPI)
                    return
                })
                
            case .failure(let encodingError):
                print(encodingError)
                
                handlerResponseAPICompletion(nil)
                return
            }
        })
    }
}
