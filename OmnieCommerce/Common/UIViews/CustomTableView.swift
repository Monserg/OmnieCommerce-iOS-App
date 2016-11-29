//
//  CustomTableView.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomTableView: UITableView {
    // MARK: - Properties
    enum Types: Int {
        case standard = 0
        case menu
    }

    @IBInspectable var mark: CGFloat = 0 {
        didSet {
            switch mark {
            // menu = 1
            case 1:
                self.backgroundColor = Config.Colors.veryDarkDesaturatedBlue25Alpha1
                
            // standard = 0
            default:
                self.backgroundColor = Config.Colors.veryDarkDesaturatedBlue25Alpha1
            }
        }
    }
}
