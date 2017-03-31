//
//  Protocols.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.02.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import CoreLocation

protocol ErrorMessageViewAnimation {
    // MARK: - Functions
    func didShow(_ view: UIView, withConstraint constraint: NSLayoutConstraint)
    func didHide(_ view: UIView, withConstraint constraint: NSLayoutConstraint)
}

protocol EmailErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var emailErrorMessageView: ErrorMessageView! { get }
    var emailErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var emailErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol PhoneErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var phoneErrorMessageView: ErrorMessageView! { get }
    var phoneErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var phoneErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol PasswordErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var passwordErrorMessageView: UIView! { get }
    var passwordErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
}

protocol RepeatPasswordErrorMessageView: ErrorMessageViewAnimation {
    // MARK: - Properties
    var repeatPasswordErrorMessageView: UIView! { get }
    var repeatPasswordErrorMessageViewTopConstraint: NSLayoutConstraint! { get set }
    var repeatPasswordErrorMessageViewHeightConstraint: NSLayoutConstraint! { get set }
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

protocol DropDownItem {
    var codeID: String! { get set }
    var name: String! { get set }
    var type: DropDownItemType! { get set }
}

protocol PointAnnotationBinding: InitCellParameters {
    // MARK: - Properties
    var name: String! { get set }
    var latitude: CLLocationDegrees? { get set }
    var longitude: CLLocationDegrees? { get set }
    var addressCity: String? { get set }
    var addressStreet: String? { get set }
}

protocol DottedBorderViewBinding {
    var dottedBorderView: DottedBorderView! { get set }
}

protocol MapObjectBinding {
    func didMap(fromDictionary dictionary: [String: Any], completion: @escaping (() -> ()))
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
            constraint.constant = -view.frame.height //Config.Constants.errorMessageViewHeight
            view.layoutIfNeeded()
            view.isHidden = true
        })
    }
}

extension ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        print("ADD PROTOCOL IMPLEMENTATION!!!")
    }
}
