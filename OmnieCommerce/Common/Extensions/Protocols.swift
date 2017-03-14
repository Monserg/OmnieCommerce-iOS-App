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
    var emailErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var emailErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol PhoneErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var phoneErrorMessageViewsCollection: [ErrorMessageView]! { get }
    var phoneErrorMessageViewTopConstraintsCollection: [NSLayoutConstraint]! { get set }
    var phoneErrorMessageViewHeightConstraintsCollection: [NSLayoutConstraint]! { get set }
}

protocol PasswordErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var passwordErrorMessageView: UIView! { get }
    var passwordErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol PasswordStrengthView {
    var passwordStrengthView: PasswordStrengthLevelView! { get }
}

protocol PasswordStrengthErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var passwordStrengthErrorMessageView: UIView! { get }
    var passwordStrengthErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var passwordStrengthErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol CodeErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var codeErrorMessageView: UIView! { get }
    var codeErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var codeErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol SearchObject {
    // MARK: - Properties
    var name: String! { get set }
}

protocol ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath)
}

protocol InitCellParameters {
    var cellIdentifier: String { get set }
    var cellHeight: CGFloat { get set }
}


extension ErrorMessageViewAnimation {
    func didShow(_ view: UIView, withConstraint constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.1, animations: {
            constraint.constant     =   0
            view.layoutIfNeeded()
        }) { success in
            UIView.animate(withDuration: 0.3, animations: {
                view.isHidden       =   false
            })
        }
    }
    
    func didHide(_ view: UIView, withConstraint constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.3, animations: {
            constraint.constant     =   -Config.Constants.errorMessageViewHeight
            view.layoutIfNeeded()
            view.isHidden           =   true
        })
    }
}

extension ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        print("ADD PROTOCOL IMPLEMENTATION!!!")
    }
}
