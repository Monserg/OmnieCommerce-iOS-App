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
    var designStyle: String?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print(object: "\(type(of: self)): \(#function) run. Button frame = \(self.frame)")
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        print(object: "\(type(of: self)): \(#function) run. Button rect = \(rect)")

        clipsToBounds = true
        
        if (designStyle == "Social") {
            let sidesRatio = Double(UIScreen.main.bounds.height / UIScreen.main.bounds.width)
            
            let circleX = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.width / 2) : Double(UIScreen.main.bounds.width * Config.Constants.bigTopBarViewWidthCoefficient - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance - Double(Config.Constants.lineViewThickness / 2) - Config.Constants.fillViewRadiusLandscape
            
            let circleY = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.height * Config.Constants.bigTopBarViewHeightCoefficient - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance - Double(Config.Constants.lineViewThickness / 2) - Config.Constants.fillViewRadiusPortrait : Double(UIScreen.main.bounds.height / 2)
            
            switch self.tag {
            // Google
            case 2:
                let googleButtonDegree = UIApplication.shared.statusBarOrientation.isPortrait ? 157.0 : 348.6
                
                center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusPortrait * cos((M_PI * googleButtonDegree) / 180), y: circleY - Config.Constants.fillViewRadiusPortrait * sin((M_PI * googleButtonDegree) / 180))
                
            // Facebook
            case 3:
                let facebookButtonDegree = UIApplication.shared.statusBarOrientation.isPortrait ? 159.6 : 344.0
                
                center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusPortrait * cos((M_PI * facebookButtonDegree) / 180), y: circleY - Config.Constants.fillViewRadiusPortrait * sin((M_PI * facebookButtonDegree) / 180))
                
            // VKontakte
            default:
                if (UIApplication.shared.statusBarOrientation.isPortrait) {
                    let vkontakteDegree = 280.1 //156.4
                    
                    center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusPortrait * cos((M_PI * vkontakteDegree) / 180), y: circleY - Config.Constants.fillViewRadiusPortrait * sin((M_PI * vkontakteDegree) / 180))
                } else {
                    let vkontakteDegree = 353.2 * (sidesRatio + 0.444)
                    
                    center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusLandscape * cos((M_PI * vkontakteDegree) / 180), y: circleY - Config.Constants.fillViewRadiusLandscape * sin((M_PI * vkontakteDegree) / 180))
                }
            }
        }
    }
}
