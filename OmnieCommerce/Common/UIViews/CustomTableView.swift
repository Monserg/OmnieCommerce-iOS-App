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
                self.backgroundColor = Config.Views.Colors.veryDarkDesaturatedBlue25Alfa1
                
            // standard = 0
            default:
                self.backgroundColor = Config.Views.Colors.veryDarkDesaturatedBlue25Alfa1
            }
        }
    }
    
    
    // MARK: - Class initialization
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
}
