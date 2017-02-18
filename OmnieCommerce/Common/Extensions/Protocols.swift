//
//  Protocols.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

protocol ErrorMessageViewAnimation {
    // MARK: - Functions
    func didShow(_ view: UIView, withConstraint constraint: NSLayoutConstraint)
    func didHide(_ view: UIView, withConstraint constraint: NSLayoutConstraint)
}

protocol EmailErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var emailErrorMessageView: UIView! { get }
    var emailErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
    var emailErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
}

protocol PasswordErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var passwordErrorMessageView: UIView! { get }
    var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
    var passwordErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
}

protocol PasswordStrengthView {
    // MARK: - Properties
    var passwordStrengthView: PasswordStrengthLevelView! { get }
}

extension ErrorMessageViewAnimation {
    func didShow(_ view: UIView, withConstraint constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.1, animations: {
            constraint.constant = 0
            view.layoutIfNeeded()
        }) { success in
            UIView.animate(withDuration: 0.3, animations: {
                view.isHidden = false
            })
        }
    }
    
    func didHide(_ view: UIView, withConstraint constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.3, animations: {
            constraint.constant = -Config.Constants.errorMessageViewHeight
            view.layoutIfNeeded()
            view.isHidden = true
        })
    }

}
