//
//  CustomView.swift
//  OmnieCommerce
//
//  Created by msm72 on 12.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {
    // MARK: - Properties
    enum StyleView: String {
        case Fill = "Fill"
        case Border = "Border"
    }
    
    @IBInspectable var style: String? {
        didSet {
            let styleCase = StyleView.init(rawValue: style!)!
            
            switch styleCase {
            case .Fill:
                layer.cornerRadius = frame.width / 2
                layer.backgroundColor = UIColor.darkCyan.cgColor
                clipsToBounds = true
                
            case .Border:
                layer.cornerRadius = bounds.width / 2
                layer.borderColor = UIColor.darkCyan.cgColor
                layer.borderWidth = 1
                clipsToBounds = true
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
    }
    
    
    // MARK: - Custom Functions
    func didShow() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha  =   1
        })
    }
    
    func didHide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha  =   0
        })
    }
}
