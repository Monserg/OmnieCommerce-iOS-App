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

//enum ApiResult<Value> {
//    case success(value: Value)
//    case failure(error: NSError)
//    
//    init(_ f: () throws -> Value) {
//        do {
//            let value   =   try f()
//            
//            self        =   .success(value: value)
//        } catch let error as NSError {
//            self        =   .failure(error: error)
//        }
//    }
//    
//    func unwrap() throws -> Value {
//        switch self {
//        case .success(let value):
//            return value
//        
//        case .failure(let error):
//            throw error
//        }
//    }
//}

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
    static let instance         =   MSMRestApiManager()
    
    var appURL: URL!
    let appHostURL              =   URL.init(string: "http://omniecom.com:9333")!
    let appApiVersionString     =   "api/v1/omnie/webservice"
    var headers                 =   [ "Content-Type": "application/json" ]

    var appApiString: String! {
        didSet {
            self.appURL         =   (self.appHostURL.appendingPathComponent(appApiVersionString)).appendingPathComponent(self.appApiString)
        }
    }
    
    // MARK: - Class Initialization
    private init() { }
    
    
    // MARK: - Class Functions
    func userAutorization(_ userName: String, andPassword password: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let authParameters      =   [ "userName": userName, "password": password ]
        appApiString            =   "/auth/"
        
        createItem(withURL: self.appURL, andParameters: authParameters, andEncoding: JSONEncoding.default, andHeaders: self.headers, withHandlerDataResponseCompletion: { dataResponse in
            if (dataResponse.result.value != nil) {
                let json            =   JSON(dataResponse.result.value!)
                let responseAPI     =   ResponseAPI.init(fromJSON: json)
                
                if (dataResponse.response?.statusCode == 200) {
                    let responseHeaders         =   dataResponse.response!.allHeaderFields
                    responseAPI.accessToken     =   responseHeaders["Authorization"] as? String
                }
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        })
    }
    
    func userRegistration(_ userName: String, andEmail email: String, andPassword password: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let authParameters          =   [ "userName": userName, "email": email, "password": password ]
        appApiString                =   "/registration/"
        
        createItem(withURL: self.appURL, andParameters: authParameters, andEncoding: JSONEncoding.default, andHeaders: self.headers, withHandlerDataResponseCompletion: { dataResponse in
            if (dataResponse.result.value != nil) {
                let json            =   JSON(dataResponse.result.value!)
                let responseAPI     =   ResponseAPI.init(fromJSON: json)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        })
    }
    
    func userForgotPassword(_ email: String, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        appApiString                =   "/forgot/"
        self.appURL                 =   URL.init(string: self.appURL.absoluteString.appending("?email=\(email)"))

        Alamofire.request(self.appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json            =   JSON(dataResponse.result.value!)
                let responseAPI     =   ResponseAPI.init(fromJSON: json)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    func userCheckEmail(_ email: String, withCode code: Int, andWithHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let checkParameters         =   [ "email": email, "code": String(code) ]
        appApiString                =   "/forgot/"
        
        Alamofire.request(self.appURL, method: .post, parameters: checkParameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json            =   JSON(dataResponse.result.value!)
                let responseAPI     =   ResponseAPI.init(fromJSON: json)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    func userChangePassword(_ email: String, withNewPassword password: String, withResetToken resetToken: String, andWithHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let saveParameters          =   [ "email": email, "password": password, "resetToken": resetToken ]
        appApiString                =   "/change-password/"
        
        Alamofire.request(self.appURL, method: .post, parameters: saveParameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json            =   JSON(dataResponse.result.value!)
                let responseAPI     =   ResponseAPI.init(fromJSON: json)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }
    
    func userGetProfileData(_ handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        headers["Authorization"] = CoreDataManager.instance.appUser.accessToken!
        appApiString = "/user/profile/"
        
        Alamofire.request(appURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            if (dataResponse.result.value != nil) {
                let json = JSON(dataResponse.result.value!)
                let responseAPI = ResponseAPI.init(fromJSON: json)
                
                handlerResponseAPICompletion(responseAPI)
                return
            } else {
                handlerResponseAPICompletion(nil)
                return
            }
        }
    }

    
    
    // MARK: - Custom REST Functions
//    func get(url: String, headers: [String: String]?, callback: @escaping (ECallbackResultType) -> Void) {}
//    
//    func update(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (ECallbackResultType) -> Void) {}
//    
//    func create(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (Bool) -> Void) {}
//    
//    func delete(url: String, parameters: [String: Any]?, headers: [String: String]?, callback: @escaping (ECallbackResultType) -> Void) {}

    
    
    
    private func createItem(withURL url: URLConvertible, andParameters parameters: [String: String]?, andEncoding encoding: ParameterEncoding, andHeaders headers: HTTPHeaders?, withHandlerDataResponseCompletion handlerDataResponseCompletion: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            handlerDataResponseCompletion(dataResponse)
            return
        }
    }
}
