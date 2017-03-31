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

public enum StatusCodeNote: Int {
    case SUCCESS                    =   200     // GET or DELETE result is successful
    case CONTINUE                   =   2201    // POST result is successful & need continue
    case CREATED                    =   201     // POST or PUT is successful
    case NOT_MODIFIED               =   304     // If caching is enabled and etag matches with the server
    case BAD_REQUEST                =   400     // Possibly the parameters are invalid
    case INVALID_CREDENTIAL         =   401     // INVALID CREDENTIAL, possible invalid token
    case NOT_FOUND                  =   404     // The item you looked for is not found
    case CONFLICT                   =   409     // Conflict - means already exist
    case AUTHENTICATION_EXPIRED     =   419     // Expired
    case BAD_AUTHORIZATION          =   4401    // BAD AUTHORIZATION
    case WRONG_INPUT_DATA           =   4500    // WRONG INPUT DATA
}

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
    func userAutorization(_ userName: String, andPassword password: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let authParameters = [ "login": userName, "password": password ]
        appApiString = "/auth/"
        
        Alamofire.request(appURL, method: .post, parameters: authParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .Default)
                
                if (dataResponse.response?.statusCode == 200) {
                    let responseHeaders = dataResponse.response!.allHeaderFields
                    UserDefaults.standard.set(responseHeaders["Authorization"] as? String, forKey: keyAccessToken)
                }
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    func userRegistration(_ userName: String, andEmail email: String, andPassword password: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let authParameters = [ "userName": userName, "email": email, "password": password ]
        appApiString = "/registration/"
        
        Alamofire.request(appURL, method: .post, parameters: authParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
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
    
    func userForgotPassword(_ email: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/forgot/"
        appURL = URL.init(string: appURL.absoluteString.appending("?email=\(email)"))

        Alamofire.request(appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { dataResponse -> Void in
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

    func userCheckEmail(_ email: String, withCode code: Int, andWithHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let checkParameters = [ "email": email, "code": String(code) ]
        appApiString = "/forgot/"
        
        Alamofire.request(appURL, method: .post, parameters: checkParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
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
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .Default))
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
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .UserDataDictionary))
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
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .UserDataDictionary))
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

    func userGetCategoriesList(withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/categories/"
        appURL = URL.init(string: appURL.absoluteString.appending("?locale=\(Locale.current.regionCode!.lowercased())"))
        
        Alamofire.request(appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .CategoriesArray)
                
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
    
    func userGetOrganizationsListByCategory(_ parameters: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .OrganizationsArray))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/organization/"
        
        Alamofire.request(appURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil && dataResponse.response!.statusCode == 200) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .OrganizationsArray)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    func userGetServicesListByCategory(_ parameters: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .ServicesArray))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/service/"
        
        Alamofire.request(appURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil && dataResponse.response!.statusCode == 200) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .ServicesArray)
                
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
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .Default))
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
    
    func userAddRemoveServiceToFavorite(_ serviceID: [String: Any], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        guard CoreDataManager.instance.appUser.accessToken != nil else {
            handlerResponseAPICompletion(ResponseAPI.init(withErrorMessage: .Default))
            return
        }
        
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/service/"
        
        Alamofire.request(appURL, method: .put, parameters: serviceID, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
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
    
    func userGetFavoriteOrganizationsList(_ parameters: [String: Int], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/user/organization/favorite/"
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        
        Alamofire.request(appURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .OrganizationsArray)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    func userGetFavoriteServicesList(_ parameters: [String: Int], withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString = "/user/service/favorite/"
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        
        Alamofire.request(appURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json, withBodyType: .ServicesArray)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

}
