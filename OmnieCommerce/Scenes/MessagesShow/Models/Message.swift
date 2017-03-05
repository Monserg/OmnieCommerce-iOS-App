//
//  Message.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

struct Message: InitCellParameters {
    // MARK: - Properties
    let title: String
    let logoStringURL: String?
    let activeDate: Date
    let text: String
    let isOwn: Bool
    let userAvatarStringURL: String?
    
    var cellIdentifier: String
    var cellHeight: CGFloat
}
