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
}


extension UIButton {
    @IBInspectable var buttonStyle: String? {
        set { setupWithStyleNamed(newValue) }
        get { return nil }
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
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.softOrange
            tintColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = frame.size.height / 2

        case .Fill:
            backgroundColor = (Config.Constants.isAppThemesLight) ? UIColor.white : Config.Colors.veryLightOrange
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.veryDarkGray
            titleLabel?.font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuRegular16
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = frame.size.height / 2

        case .Border:
            backgroundColor = UIColor.clear
            tintColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.veryLightGray
            titleLabel?.font = (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 12) : Config.Fonts.ubuntuRegular16
            borderColor = (Config.Constants.isAppThemesLight) ? UIColor.black : Config.Colors.veryLightOrange
            borderWidth = 1
            cornerRadius = frame.size.height / 2
            
        case .Underline:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightVeryLightGrayUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightVeryLightGrayUnderline12), for: .normal)
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightVeryLightGrayUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightVeryLightGrayUnderline12), for: .highlighted)

        case .UnderlineColor:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightSoftOrangeUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightSoftOrangeUnderline12), for: .normal)
            (Config.Constants.isAppThemesLight) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightSoftOrangeUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: Config.Fonts.ubuntuLightSoftOrangeUnderline12), for: .highlighted)
        }
    }
}
