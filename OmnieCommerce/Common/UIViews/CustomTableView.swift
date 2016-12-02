
//  CustomTableView.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum TableCellStyle: String {
    case Menu = "Menu"
    case DropDown = "DropDown"
    case Standard = "Standard"
}

@IBDesignable class CustomTableView: UITableView {
    // MARK: - Properties
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }

    @IBInspectable var tableCellStyle: String? {
        didSet {
            switch TableCellStyle.init(rawValue: tableCellStyle!)! {
            case .Menu:
                self.backgroundColor = UIColor.veryDarkDesaturatedBlue25Alpha1
                
            case .DropDown:
                self.backgroundColor = UIColor.veryDarkDesaturatedBlue24

            default:
                self.backgroundColor = UIColor.veryDarkDesaturatedBlue25Alpha1
            }
        }
    }
    
    func setScrollIndicatorColor(color: UIColor) {
        for view in self.subviews {
            if view.isKind(of: UIImageView.self), let imageView = view as? UIImageView, let image = imageView.image {
                imageView.tintColor = color
                imageView.image = image.withRenderingMode(.alwaysTemplate)
            }
        }
        
        self.flashScrollIndicators()
    }
}
