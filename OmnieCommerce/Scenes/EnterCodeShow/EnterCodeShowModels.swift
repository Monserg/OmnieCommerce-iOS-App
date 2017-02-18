//
//  EnterCodeShowModels.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 07.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Data models
struct EnterCodeShowModels {
    struct Renew {
        struct RequestModel {
            let email: String
        }
        
        struct ResponseModel {
            let success: Bool
        }
        
        struct ViewModel {
            let success: Bool
        }
    }
}
