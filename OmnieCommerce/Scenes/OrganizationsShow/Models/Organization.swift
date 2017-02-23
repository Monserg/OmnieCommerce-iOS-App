
//
//  Organization.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

struct Organization {
    // MARK: - Properties
    let codeID: Int!
    let name: String!
    let addressCity: String!
    let addressStreet: String!
    var logoURL: String?
    var rating: Int         =   0
    var isFavorite: Bool    =   false
}
