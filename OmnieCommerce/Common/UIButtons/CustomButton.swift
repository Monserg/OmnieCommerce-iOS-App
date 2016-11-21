//
//  CustomButton.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        
        if (buttonStyle == "Social") {
            let sidesRatio = Double(UIScreen.main.bounds.height / UIScreen.main.bounds.width)
            
            let circleX = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.width / 2) : (205.0 - Config.Constants.circleViewRadiusSmall - Double(Config.Constants.topViewBarLineThickness / 2))
            let circleY = UIApplication.shared.statusBarOrientation.isPortrait ? (205.0 - Config.Constants.circleViewRadiusSmall) : Double(UIScreen.main.bounds.height / 2)
            let degreeVkontakte = UIApplication.shared.statusBarOrientation.isPortrait ? 154.4 * sidesRatio : 353.2 * (sidesRatio + 0.444)
            let degreeGoogle = UIApplication.shared.statusBarOrientation.isPortrait ? 157.0 * sidesRatio : 348.6 * (sidesRatio + 0.444)
            let degreeFacebook = UIApplication.shared.statusBarOrientation.isPortrait ? 159.6 * sidesRatio : 344.0 * (sidesRatio + 0.444)
            
            switch self.tag {
            // Google
            case 2:
                center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeGoogle)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeGoogle)/180))
                
            // Facebook
            case 3:
                center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeFacebook)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeFacebook)/180))
                
            // Vkontakte
            default:
                center = CGPoint(x: circleX + Config.Constants.circleViewRadiusSmall * cos((M_PI * degreeVkontakte)/180), y: circleY - Config.Constants.circleViewRadiusSmall * sin((M_PI * degreeVkontakte)/180))
            }
        }
    }
}
