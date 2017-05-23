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
    var handlerHiddenCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Custom Functions
    override func didShow(_ value: Bool, withConstraint constraint: NSLayoutConstraint) {
        guard (isHidden && value) || (!isHidden && !value) else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            constraint.constant = (value) ? 0 : -self.frame.height
            self.layoutIfNeeded()
        }, completion: { success in
            UIView.animate(withDuration: 0.3, animations: {
                self.isHidden = (value) ? false : true
                self.handlerHiddenCompletion!(self.isHidden)
            })
        })
    }
}
