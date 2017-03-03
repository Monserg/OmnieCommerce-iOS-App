//
//  NewsShowModels.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Data models
struct NewsShowModels {
    struct NewsItems {
        struct RequestModel {
        }
        
        struct ResponseModel {
            let items: [News]
        }
        
        struct ViewModel {
            let news: [[News]]?
        }
    }
}
