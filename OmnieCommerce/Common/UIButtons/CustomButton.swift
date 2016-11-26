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
            
            var buttonDegree = 180.0
            
            switch self.tag {
            // Google
            case 2:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 288.1 : 332.1 * (sidesRatio + 0.444)
                
            // Facebook
            case 3:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 296.1 : 322.1 * (sidesRatio + 0.444)
                
            // VKontakte
            default:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 280.1 : 342.1 * (sidesRatio + 0.444)
            }
            
            if (UIApplication.shared.statusBarOrientation.isPortrait) {
                center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusPortrait * cos((M_PI * buttonDegree) / 180), y: circleY - Config.Constants.fillViewRadiusPortrait * sin((M_PI * buttonDegree) / 180))
            } else {
                center = CGPoint.init(x: circleX + Config.Constants.fillViewRadiusLandscape * cos((M_PI * buttonDegree) / 180), y: circleY - Config.Constants.fillViewRadiusLandscape * sin((M_PI * buttonDegree) / 180))
            }
        }
    }
}
