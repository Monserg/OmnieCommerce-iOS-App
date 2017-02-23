//
//  OrganizationsShowModels.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Data models
struct OrganizationsShowModels {
    struct Organizations {
        struct RequestModel {
            
        }
        
        struct ResponseModel {
            let result: [Organization]
        }
        
        struct ViewModel {
            let organizations: [Organization]
        }
    }
}
