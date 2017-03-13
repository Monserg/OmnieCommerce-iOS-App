//
//  MSMRestApiManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire

enum ApiResult<Value> {
    case success(value: Value)
    case failure(error: NSError)
    
    init(_ f: () throws -> Value) {
        do {
            let value = try f()
            
            self    =   .success(value: value)
        } catch let error as NSError {
            self    =   .failure(error: error)
        }
    }
    
    func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        
        case .failure(let error):
            throw error
        }
    }
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
    func userAutorization(_ userName: String, andPassword password: String, withResponseCompletionHandler responseCompletionHandler: @escaping (ApiResult<Bool>) -> Void) {
        let authParameters      =   [ "userName": userName, "password": password ]
        appApiString            =   "/auth/"
        
        postRequestDidRun(withURL: self.appURL, andParameters: authParameters, andEncoding: JSONEncoding.default, andHeaders: self.headers, withResponseCompletionHandler: { (success) in
            responseCompletionHandler(success)
            
            return
        })
    }
    
    
    // MARK: - Custom Functions
    func postRequestDidRun(withURL url: URLConvertible, andParameters parameters: [String: String]?, andEncoding encoding: ParameterEncoding, andHeaders headers: HTTPHeaders?, withResponseCompletionHandler responseCompletionHandler: @escaping (ApiResult<Bool>) -> Void) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            
            responseCompletionHandler(.success(value: true))
            return
        }
    }
}
