//
//  PersonalPageShowModels.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Data models
struct PersonalPageShowModels {
    struct ChangeEmail {
        struct RequestModel {
            let email: String
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
        }
        
        struct ViewModel {
            let responseAPI: ResponseAPI?
        }
    }
    
    struct LoadData {
        struct RequestModel {
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
        }
        
        struct ViewModel {
            let responseAPI: ResponseAPI?
        }
    }

    struct UploadData {
        struct RequestModel {
            let parameters: Any
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
            let passwordsParams: [String: Any]?
        }
        
        struct ViewModel {
            let status: String
            let passwordsParams: [String: Any]?
        }
    }

    struct UploadImage {
        struct RequestModel {
            let image: UIImage
        }
        
        struct ResponseModel {
            let responseAPI: ResponseAPI?
        }
        
        struct ViewModel {
            let status: String
        }
    }
    
    struct Templates {
        struct RequestModel {
            let userID: String
        }
        
        struct ResponseModel {
            let items: [Organization]?
        }
        
        struct ViewModel {
            let organizations: [Organization]?
        }
    }
}
