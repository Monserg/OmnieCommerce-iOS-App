//
//  DropDownItem.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

enum DropDownItemType: String {
    case City                   =   "City"
    case Service                =   "Service"
    case Subcategory            =   "Subcategory"
    case OrganizationService    =   "OrganizationService"
}

class DropDownValue: DropDownItem, InitCellParameters {
    // MARK: - Properties
    var name: String!
    var codeID: String!
    var type: DropDownItemType!
    
    var cellIdentifier: String = "DropDownTableViewCell"
    var cellHeight: CGFloat = Config.Constants.dropDownCellHeight

    
    // MARK: - Class Initialization
    init(_ codeID: String, withName name: String, andType type: DropDownItemType) {
        self.codeID = codeID
        self.name = name
        self.type = type
    }
}
