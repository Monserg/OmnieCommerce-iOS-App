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
    var isButtonsTreeShow = false
    
    
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
            let circleX = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.width / 2) : Double(UIScreen.main.bounds.width * Config.Constants.bigTopBarViewWidthCoefficient - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance - Double(Config.Constants.lineViewThickness / 2) - Config.Constants.fillViewBigRadiusLandscape
            
            let circleY = UIApplication.shared.statusBarOrientation.isPortrait ? Double(UIScreen.main.bounds.height * Config.Constants.bigTopBarViewHeightCoefficient - Config.Constants.lineViewThickness) - Config.Constants.lineViewSocialButtonDistance - Double(Config.Constants.lineViewThickness / 2) - Config.Constants.fillViewBigRadiusPortrait : Double(UIScreen.main.bounds.height / 2)
            
            var buttonDegree = 180.0
            let ratio = Double(UIScreen.main.bounds.width / 320)
            
            
            switch self.tag {
            // Google
            case 1:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 282.6 + ratio : 340.1 + ratio
                
            // Facebook
            case 2:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 290.1 + ratio : 331.1 + ratio
                
            // VKontakte
            default:
                buttonDegree = (UIApplication.shared.statusBarOrientation.isPortrait) ? 275.1 + ratio : 349.1 + ratio
            }
            
            if (UIApplication.shared.statusBarOrientation.isPortrait) {
                center = CGPoint.init(x: circleX + Config.Constants.fillViewBigRadiusPortrait * cos((M_PI * buttonDegree) / 180), y: circleY - Config.Constants.fillViewBigRadiusPortrait * sin((M_PI * buttonDegree) / 180))
            } else {
                center = CGPoint.init(x: circleX + Config.Constants.fillViewBigRadiusLandscape * cos((M_PI * buttonDegree) / 180), y: circleY - Config.Constants.fillViewBigRadiusLandscape * sin((M_PI * buttonDegree) / 180))
            }
        }
        
        layoutIfNeeded()
        layer.cornerRadius = frame.height / 2
    }
    
    
    // MARK: - Custom Functions
    func didShowButtonsTree() {
        // Button animation
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 45.0 * ((self.isButtonsTreeShow) ? 0 : 1)) / 180)
        }, completion: { success in
            // Create Business Card button
            let businessCardButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            businessCardButton.center = self.center
            businessCardButton.backgroundColor = UIColor.red // veryLightOrange
            businessCardButton.addTarget(self, action: #selector(self.handlerButtonFromTreeTap), for: .touchUpInside)
            
            self.addSubview(businessCardButton)
            
            self.isButtonsTreeShow = !self.isButtonsTreeShow
        })
    }
    
    func handlerButtonFromTreeTap(_ sender: UIButton) {
        print(object: "asdasdasdas")
    }
}
