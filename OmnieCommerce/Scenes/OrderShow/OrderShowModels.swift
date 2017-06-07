//
//  OrderShowModels.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Data models
struct OrderShowModels {
    struct OrderItem {
        struct RequestModel {
            let parameters: [String: Any]
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
        }
        
        struct ViewModel {
            let status: String
            let orderID: String?
        }
    }

    struct TotalPrice {
        struct RequestModel {
            let parameters: [String: Any]
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
        }
        
        struct ViewModel {
            let status: String
            let value: Double?
        }
    }
}
