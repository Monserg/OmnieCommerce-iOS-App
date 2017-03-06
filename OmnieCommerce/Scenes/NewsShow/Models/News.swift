//
//  News.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

struct News: InitCellParameters, SearchObject {
    // MARK: - Properties
    var name: String!
    let logoStringURL: String?
    let activeDate: Date
    let description: String
    
    var cellIdentifier: String
    var cellHeight: CGFloat
}
