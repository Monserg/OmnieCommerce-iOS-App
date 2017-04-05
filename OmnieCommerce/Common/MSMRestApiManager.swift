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
    case userCheckEmail([String: Any], Bool)
    case userAutorization([String: Any], Bool)
    case userRegistration([String: Any], Bool)
    case userForgotPassword([String: Any], Bool)
    case userGetActionsList([String: Any], Bool)
    case userGetNewsDataByID([String: Any], Bool)
    case userGetNewsDataList([String: Any], Bool)
    case userGetCategoriesList([String: Any], Bool)
    case userGetFavoriteServicesList([String: Any], Bool)
    case userGetServicesListByCategory([String: Any], Bool)
    case userAddRemoveServiceToFavorite([String: Any], Bool)
    case userGetFavoriteOrganizationsList([String: Any], Bool)
    case userGetOrganizationsListByCategory([String: Any], Bool)
    
    
    
//    case ([String: Any], Bool)
//    case ([String: Any], Bool)
//    case ([String: Any], Bool)
//    case ([String: Any], Bool)
//    case ([String: Any], Bool)

    func introduced() -> RequestParametersType {
        let headers = [ "Content-Type": "application/json" ]
        let userAccessToken = CoreDataManager.instance.appUser.accessToken
        let headersExtended = (userAccessToken != nil) ? [ "Content-Type": "application/json", "Authorization" : userAccessToken! ] : nil
        
        // Body & Parametes named such as in Postman
        switch self {
        // Forgot password, step 2
        case .userCheckEmail(let params, let isBodyParams):     return (method: .post,
                                                                        apiStringURL: "/forgot/",
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
            
        case .userRegistration(let params, let isBodyParams):   return (method: .post,
                                                                        apiStringURL: "/registration/",
                                                                        body: (isBodyParams ? params : nil),
                                                                        bodyType: .Default,
                                                                        headers: headers,
                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userForgotPassword(let params, let isBodyParams):     return (method: .get,
                                                                            apiStringURL: "/forgot/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .Default,
                                                                            headers: headers,
                                                                            parameters: (isBodyParams ? nil : params))

        case .userGetActionsList(let params, let isBodyParams):     return (method: .post,
                                                                            apiStringURL: "/user/promotion/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))

        // TODO: ADD REQUEST VIP-CYCLE WITH ISBODYPARAMS = FALSE
        case .userGetNewsDataByID(let params, let isBodyParams):    return (method: .get,
                                                                            apiStringURL: "/user/news/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetNewsDataList(let params, let isBodyParams):    return (method: .post,
                                                                            apiStringURL: "/user/news/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headersExtended,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetCategoriesList(let params, let isBodyParams):  return (method: .get,
                                                                            apiStringURL: "/categories/",
                                                                            body: (isBodyParams ? params : nil),
                                                                            bodyType: .ItemsArray,
                                                                            headers: headers,
                                                                            parameters: (isBodyParams ? nil : params))
            
        case .userGetFavoriteServicesList(let params, let isBodyParams):    return (method: .post,
                                                                                    apiStringURL: "/user/service/favorite/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsArray,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userGetServicesListByCategory(let params, let isBodyParams):  return (method: .post,
                                                                                    apiStringURL: "/user/service/",
                                                                                    body: (isBodyParams ? params : nil),
                                                                                    bodyType: .ItemsArray,
                                                                                    headers: headersExtended,
                                                                                    parameters: (isBodyParams ? nil : params))
            
        case .userAddRemoveServiceToFavorite(let params, let isBodyParams):     return (method: .put,
                                                                                        apiStringURL: "/user/service/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .Default,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))

        case .userGetFavoriteOrganizationsList(let params, let isBodyParams):   return (method: .post,
                                                                                        apiStringURL: "/user/organization/favorite/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .ItemsArray,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
        case .userGetOrganizationsListByCategory(let params, let isBodyParams): return (method: .post,
                                                                                        apiStringURL: "/user/organization/",
                                                                                        body: (isBodyParams ? params : nil),
                                                                                        bodyType: .ItemsArray,
                                                                                        headers: headersExtended,
                                                                                        parameters: (isBodyParams ? nil : params))
            
            
//        case .(let params, let isBodyParams): return (method: .,
//                                                                                        apiStringURL: "",
//                                                                                        body: (isBodyParams ? params : nil),
//                                                                                        bodyType: .ItemsArray,
//                                                                                        headers: headersExtended,
//                                                                                        parameters: (isBodyParams ? nil : params))

        }
    }
}


// REMOVED!!!
//news by id










final class MSMRestApiManager {
    // MARK: - Properties
    static let instance = MSMRestApiManager()
    
    var appURL: URL!
    let appHostURL = URL.init(string: "http://omniecom.com:9333")!
    let appApiVersionString = "api/v1/omnie/webservice"
    var headers = [ "Content-Type": "application/json" ]

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
            let key = requestParameters.parameters!.keys.first!
            let value = requestParameters.parameters![key] as! String
            appURL = URL.init(string: appURL.absoluteString.appending("?\(key)=\(value)"))
        }
        
        Alamofire.request(appURL, method: requestParameters.method, parameters: requestParameters.body, encoding: JSONEncoding.default, headers: requestParameters.headers).responseJSON { dataResponse -> Void in
            guard dataResponse.error == nil && dataResponse.result.value != nil else {
                handlerResponseAPICompletion(nil)
                return
            }
            
            let json = JSON(dataResponse.result.value!)
            let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: requestParameters.bodyType)
            
            // Save headers
            if (dataResponse.response?.statusCode == 200 && requestParameters.bodyType == .Default) {
                let responseHeaders = dataResponse.response!.allHeaderFields
                UserDefaults.standard.set(responseHeaders["Authorization"] as? String, forKey: keyAccessToken)
            }

            handlerResponseAPICompletion(responseAPI)
            return
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    

    // Change current E-mail
    func userChangeEmail(_ email: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/user/email/"
        appURL = URL.init(string: appURL.absoluteString.appending("?email=\(email)"))
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        
        Alamofire.request(appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    // Change Password during Authorization
    func userChangePasswordFromLogin(_ email: String, withNewPassword password: String, withResetToken resetToken: String, andWithHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let saveParameters = [ "email": email, "password": password, "resetToken": resetToken ]
        appApiString = "/change-password/"
        
        Alamofire.request(appURL, method: .post, parameters: saveParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    // Change Password from Profile
    func userChangePasswordFromProfile(_ parameters: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
//            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .Default))
            return
        }
        
        var params = parameters
        params["currentPassword"] = CoreDataManager.instance.appUser.password!
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/password/"
        
        Alamofire.request(appURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    func userGetProfileData(_ handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
//            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .UserDataDictionary))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/profile/"
        
        Alamofire.request(appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json,
                                                   withBodyType: ((dataResponse.response!.statusCode == 200) ? .UserDataDictionary : .UserAdditionalDataDictionary))
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    func userUploadProfileData(_ parameters: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
//            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .UserDataDictionary))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        headers["Role"] = "admin"
        appApiString = "/user/profile/"
        
        Alamofire.request(appURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil && dataResponse.response!.statusCode == 200) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .UserDataDictionary)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    func userUploadImage(_ image: UIImage, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let imageData = UIImagePNGRepresentation(image)
        appApiString = "/user/profile/image/"
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        headers["Content-Type"] = "multipart/form-data"
       
        let uploadURL = try! URLRequest(url: appURL, method: .post, headers: headers)
        
        guard imageData != nil else {
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "uploaded_file", fileName: "userImage.jpg", mimeType: "image/jpeg")
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

    func userDeleteImage(withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/user/profile/image/"
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        
        Alamofire.request(appURL, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    func userAddRemoveOrganizationToFavorite(_ organizationID: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
//            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .Default))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/organization/"
        
        Alamofire.request(appURL, method: .put, parameters: organizationID, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
}
