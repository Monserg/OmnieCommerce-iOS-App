//
//  UIButton+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 21.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

/// Стиль кнопки
enum ButtonStyle: String {
    /// Светлый стиль
    case Light              =   "light"
    
    /// Темный стиль
    case Dark               =   "dark"
    
    /// Оттенок
    var tintColor: UIColor {
        switch self {
        case .Light:
            return UIColor.black
        
        case .Dark:
            return UIColor.lightGray
        }
    }
    
    /// Цвет границы
    var borderColor:        UIColor { return tintColor }

    /// Цвет фона
    var backgroundColor:    UIColor { return UIColor.clear }
    
    /// Толщина границы
    var borderWidth:        CGFloat { return 1 }
    
    /// Радиус границы
    var cornerRadius:       CGFloat { return 4 }
}


extension UIButton {
    /// Стиль кнопки
    @IBInspectable var style: String? {
        set { setupWithStyleNamed(newValue) }
        get { return nil }
    }
    
    /// Применение стиля по его строковому названию
    func setupWithStyleNamed(_ named: String?) {
        if let styleName = named, let style = ButtonStyle(rawValue: styleName) {
            setupWithStyle(style)
        }
    }
    
    /// Применение стиля по его идентификатору
    func setupWithStyle(_ style: ButtonStyle) {
        backgroundColor     =   style.backgroundColor
        tintColor           =   style.tintColor
        borderColor         =   style.borderColor
        borderWidth         =   style.borderWidth
        cornerRadius        =   style.cornerRadius
    }
}
