//
//  CustomButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    // MARK: - Properties
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    enum Types {
        case social
        case standard
    }

    var type: Types = .standard
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        if (self.type == .social) {
            let sidesRatio = Double(UIScreen.main.bounds.height / UIScreen.main.bounds.width)
            
            let circleX = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.width / 2) : (203.0 - Config.Constants.circleViewRadiusSmall)
            let circleY = UIApplication.shared.statusBarOrientation.isPortrait ? (203.0 - Config.Constants.circleViewRadiusSmall) : Double(UIScreen.main.bounds.height / 2)
            let degreeVkontakte = UIApplication.shared.statusBarOrientation.isPortrait ? 155.0 * sidesRatio : 352.0 * (sidesRatio + 0.444)
            let degreeGoogle = UIApplication.shared.statusBarOrientation.isPortrait ? 157.3 * sidesRatio : 348.0 * (sidesRatio + 0.444)
            let degreeFacebook = UIApplication.shared.statusBarOrientation.isPortrait ? 159.6 * sidesRatio : 344.0 * (sidesRatio + 0.444)
            
            self.layer.backgroundColor = Config.Buttons.Colors.softOrange?.cgColor

            switch self.tag {
            // Google
            case 2:
                self.center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeGoogle)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeGoogle)/180))
                
            // Facebook
            case 3:
                self.center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeFacebook)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeFacebook)/180))
                
            // Vkontakte
            default:
                self.center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeVkontakte)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeVkontakte)/180))
            }
        }
    }

}
