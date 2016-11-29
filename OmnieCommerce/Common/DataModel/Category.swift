//
//  Category.swift
//  OmnieCommerce
//
//  Created by msm72 on 29.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import Localize_Swift

class Category: NSObject {
    // MARK: - Properties
    var title: String
    var icon: String

    
    // MARK: - Class Initialization
    init(_ title: String, _ icon: String) {
        self.title = title.localized()
        self.icon = icon
        
        super.init()
    }
}
