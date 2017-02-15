//
//  ErrorMessageView.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 07.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class ErrorMessageView: UIView {
    // MARK: - Properties

    
    // MARK: - Custom Functions
    func didShow(_ value: Bool, withConstraint constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 1.3, animations: {
            constraint.constant = (value) ? 0 : -self.frame.height
            
            self.layoutIfNeeded()
        })
    }
}
