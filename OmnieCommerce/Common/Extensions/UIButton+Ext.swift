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
    case SoftOrangeFill                                 =   "SoftOrangeFill"
    case VeryLightOrangeFill                            =   "VeryLightOrangeFill"
    case Border = "Border"
    case Underline = "Underline"
    case UnderlineColor = "UnderlineColor"
    case DropDownList = "DropDownList"
    case MenuEvent = "MenuEvent"
    case Circular = "Circular"
    case ActionViewOrangeButton                                 =   "ActionViewOrangeButton"
    case TitleUbuntuLight12UndirlineVeryLightGray               =   "TitleUbuntuLight12UndirlineVeryLightGray"
    case TitleUbuntuLightItalic12UndirlineVeryLightOrange       =   "TitleUbuntuLightItalic12UndirlineVeryLightOrange"
    case TitleUbuntuRegular21SoftOrange                         =   "TitleUbuntuRegular21SoftOrange"

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
        let titleText = (titleLabel?.text != nil) ? (titleLabel?.text!.localized())! : String()
        setTitle(titleText, for: .normal)
        setTitle(titleText, for: .highlighted)
        
        switch buttonStyle {
        case .Social:
            backgroundColor = (isAppThemeDark) ? UIColor.white : UIColor.softOrange
            tintColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0

        case .VeryLightOrangeFill, .SoftOrangeFill:
            backgroundColor = (isAppThemeDark) ? UIColor.white : ((buttonStyle == .VeryLightOrangeFill) ? UIColor.veryLightOrange : UIColor.softOrange)
            setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuRegularVeryDarkGray16), for: .normal)
            borderColor = UIColor.clear
            borderWidth = 0

            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuRegularVeryDarkGray16), for: .normal)
            
            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: titleText, attributes: UIFont.ubuntuRegularVeryDarkGray16), for: .highlighted)

            titleLabel?.sizeToFit()

            if (imageView?.image != nil && !titleText.isEmpty) {
                imageEdgeInsets = UIEdgeInsetsMake(3, (titleLabel?.frame.maxX)! + 5, 0, 0)
            }
            
        case .Border:
            backgroundColor = UIColor.clear
            tintColor = (isAppThemeDark) ? UIColor.black : UIColor.veryLightGray
            titleLabel?.font = (isAppThemeDark) ? UIFont.systemFont(ofSize: 12) : UIFont.ubuntuRegular16
            borderColor = (isAppThemeDark) ? UIColor.black : UIColor.veryLightOrange
            borderWidth = 1
            
        case .Underline:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            
            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .normal)
            
            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightVeryLightGrayUnderline12), for: .highlighted)

        case .UnderlineColor:
            backgroundColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0
            cornerRadius = 0
            
            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .normal) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .normal)
            
            (isAppThemeDark) ? setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .highlighted) : setAttributedTitle(NSAttributedString.init(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightSoftOrangeUnderline12), for: .highlighted)
            
        case .DropDownList:
            backgroundColor = (isAppThemeDark) ? UIColor.white : UIColor.veryDarkDesaturatedBlue24
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
            borderColor = UIColor.darkCyan
            borderWidth = 1.0
            cornerRadius = 5.0
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            imageEdgeInsets = UIEdgeInsetsMake(3, frame.width - 18 - borderWidth, 0, 0)

        case .MenuEvent:
            backgroundColor = (isAppThemeDark) ? UIColor.white : UIColor.veryLightOrange
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightGray12Alpha30), for: .highlighted)
            borderColor = UIColor.darkCyan
            borderWidth = 1.0
            cornerRadius = 5.0
            titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            imageEdgeInsets = UIEdgeInsetsMake(3, frame.width - 18 - borderWidth, 0, 0)
        
        case .Circular:
            tintColor = UIColor.clear
            borderColor = UIColor.clear
            borderWidth = 0

        case .ActionViewOrangeButton:
            backgroundColor = (isAppThemeDark) ? UIColor.white : UIColor.clear
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightOrange12), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text)!, attributes: UIFont.ubuntuLightVeryLightOrange12Alpha30), for: .highlighted)
            
        case .TitleUbuntuLight12UndirlineVeryLightGray:
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLight12UnderlineVeryLightGray), for: .normal)
            
        case .TitleUbuntuLightItalic12UndirlineVeryLightOrange:
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightItalic12UnderlineVeryLightOrange), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuLightItalic12UnderlineVeryLightOrangeAlpha30), for: .highlighted)
            
        case .TitleUbuntuRegular21SoftOrange:
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuRegularSoftOrange21), for: .normal)
            setAttributedTitle(NSAttributedString(string: (titleLabel?.text?.localized())!, attributes: UIFont.ubuntuRegularSoftOrange21Alpha30), for: .highlighted)
        }
    }
    
    func setVerticalTitleStyle() {
        setTitle(String().verticalStyle(string: (titleLabel?.text)!), for: .normal)
        contentEdgeInsets           =   UIEdgeInsetsMake(0, 22, 0, 21)
        titleLabel?.numberOfLines   =   0
        titleLabel?.textAlignment   =   .center
    }
    
    func setAttributedTitleWithoutAnimation(title: NSAttributedString) {
        UIView.setAnimationsEnabled(false)
        setAttributedTitle(title, for: .normal)
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}
