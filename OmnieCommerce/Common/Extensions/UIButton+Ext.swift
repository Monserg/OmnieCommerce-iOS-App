//
//  UIButton+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 21.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

enum ButtonStyle: String {
    case Social = "Social"
    case Fill = "Fill"
    case Border = "Border"
    case Underline = "Underline"
    case UnderlineColor = "UnderlineColor"
    case DropDownList = "DropDownList"
    case MenuEvent = "MenuEvent"
}


extension UIButton {
    @IBInspectable var buttonStyle: String? {
        set { setupWithStyleNamed(newValue) }
        get { return nil }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }

    func setupWithStyleNamed(_ named: String?) {
        if let styleName = named, let buttonStyle = ButtonStyle(rawValue: styleName) {
            setupWithStyle(buttonStyle)
        }
    }
    
    func setupWithStyle(_ buttonStyle: ButtonStyle) {
        setTitle(titleLabel?.text?.localized(), for: .normal)
        setTitle(titleLabel?.text?.localized(), for: .highlighted)

        switch buttonStyle {
        case .Social:
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.softOrange
            tintColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = frame.size.height / 2

        case .Fill:
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightOrange
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.black : UIColor.veryDarkGray
            titleLabel?.font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = frame.size.height / 2

        case .Border:
            backgroundColor = UIColor.clear
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.black : UIColor.veryLightGray
            titleLabel?.font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : UIColor.veryLightOrange
            borderWidth = 1
            cornerRadius = frame.size.height / 2
            
        case .Underline:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal)
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted)

        case .UnderlineColor:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .normal)
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .highlighted)
            
        case .DropDownList:
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryDarkDesaturatedBlue24
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
            borderColor = UIColor.darkCyan
            borderWidth = 1.0
            cornerRadius = 5.0
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            imageEdgeInsets = UIEdgeInsetsMake(3, frame.width - 18 - borderWidth, 0, 0)

        case .MenuEvent:
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : UIColor.veryLightOrange
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
            borderColor = UIColor.darkCyan
            borderWidth = 1.0
            cornerRadius = 5.0
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            imageEdgeInsets = UIEdgeInsetsMake(3, frame.width - 18 - borderWidth, 0, 0)
        }
    }
}
