//
//  NSObject+Ext.swift
//  OmnieCommerce
//
//  http://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift
//
//
//  Created by msm72 on 04.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
