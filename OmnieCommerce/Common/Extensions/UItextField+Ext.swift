//
//  UItextField+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 27.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension UITextField {
    // MARK: - Custom Functions
    func changeClearButtonColor() {
        // Change clear button color
        if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            
            // Finally, set the image color
            clearButton.tintColor = self.tintColor
        }
    }
}
