//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalDataViewController: BaseViewController, EmailErrorMessageView, PhoneErrorMessageView, PasswordErrorMessageView, PasswordStrengthView, PasswordStrengthErrorMessageView {
    // MARK: - Properties
    var parametersForAPI: [String: String]?
    var phoneLastTag: Int                   =   2
    var phonesCount: Int                    =   0
    var onePhoneViewHeight: CGFloat         =   0
    var deleteButtonsCollection             =   [FillVeryLightOrangeButton]()
    var phoneViewsCollection                =   [NewPhoneView]()

    // Protocol PhoneErrorMessageView
    var phoneErrorMessageViewsCollection                    =   [ErrorMessageView]()
    var phoneErrorMessageViewTopConstraintsCollection       =   [NSLayoutConstraint]()
    var phoneErrorMessageViewHeightConstraintsCollection    =   [NSLayoutConstraint]()

    var pickerViewManager: MSMPickerViewManager! {
        didSet {
            guard birthdayPickerView != nil else {
                return
            }
            
            birthdayPickerView.delegate     =   self.pickerViewManager
            birthdayPickerView.dataSource   =   self.pickerViewManager

            let currentDayComponents        =   Calendar.current.dateComponents(in: TimeZone.current, from: Date())
            let currentMonthIndex           =   pickerViewManager.months.index(where: { $0 == String(currentDayComponents.month!) })!
            let currentDaysInMonth          =   pickerViewManager.days[currentMonthIndex]
            let currentDayIndex             =   currentDaysInMonth.index(where: { $0 == String(currentDayComponents.day!) })!
            let currentYearIndex            =   pickerViewManager.years.index(where: { $0 == String(currentDayComponents.year!) })!
            
            birthdayPickerView.selectRow(currentDayIndex, inComponent: 0, animated: true)
            birthdayPickerView.selectRow(currentMonthIndex, inComponent: 2, animated: true)
            birthdayPickerView.selectRow(currentYearIndex, inComponent: 4, animated: true)
        }
    }
    
    var handlerSaveButtonCompletion: HandlerSaveButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    
    var textFieldManager: MSMTextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarButton: CustomButton!
    @IBOutlet weak var passwordsView: UIView!
    @IBOutlet weak var phonesView: UIView!
    @IBOutlet weak var changePasswordButton: UbuntuLightItalicDarkCyanButton!
    @IBOutlet weak var birthdayPickerView: UIPickerView!
    
    @IBOutlet var textFieldsCollection: [CustomTextField]! {
        didSet {
            textFieldManager            =   MSMTextFieldManager(withTextFields: textFieldsCollection)
            textFieldManager.currentVC  =   self
            
            _ = textFieldsCollection.map({ textField in
                // PhoneButton style
                if (textField.style! == .PhoneButton) {
                    // Handler Show/Hide Delete Button
                    self.textFieldManager.handlerTextFieldCompletion                =   { (phoneButtonTextField, success) in
                        if (self.phoneLastTag != 0) {
                            let deleteButton        =   self.deleteButtonsCollection.first(where: { $0.tag == phoneButtonTextField.tag })
                            deleteButton?.isHidden  =   (self.phoneErrorMessageViewsCollection.count == 1) ? true : false
                        }
                    }
                    
                    // Handler Add New Phone View
                    self.textFieldManager.handlerPassDataCompletion                 =   { phoneButtonTextField in
                        self.phoneViewDidAdd()
                    }

                    // Handler Show/Hide Phone Error Message View
                    self.textFieldManager.handlerTextFieldShowErrorViewCompletion   =   { (phoneButtonTextField, isShow) in
                        let phoneErrorView          =   self.phoneErrorMessageViewsCollection.first(where: { $0.tag == phoneButtonTextField.tag })!
                        let phoneErrorViewIndex     =   self.phoneErrorMessageViewsCollection.index(of: phoneErrorView)!

                        if ((phoneErrorView.isHidden && isShow) || (!phoneErrorView.isHidden && !isShow)) {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.phonesViewHeightConstraint.constant            +=   14 * ((isShow) ? 1 : -1)
                            }, completion: { success in
                                phoneErrorView.didShow(isShow, withConstraint: self.phoneErrorMessageViewTopConstraintsCollection[phoneErrorViewIndex])
                            })
                        }
                    }
                }
            })
        }
    }
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map{ $0.style = .BottomDottedLine }
        }
    }
    
    @IBOutlet var radioButtonsCollection: [DLRadioButton]! {
        didSet {
            radioButtonsCollection!.first!.isSelected   =   (userApp!.gender == 1) ? false : true
            radioButtonsCollection!.last!.isSelected    =   (userApp!.gender == 1) ? true : false
        }
    }
    
    @IBOutlet weak var passwordsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: UIView!
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol PasswordErrorMessageView
    @IBOutlet weak var passwordErrorMessageView: UIView!
    @IBOutlet weak var passwordErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint!

    // Protocol PasswordStrengthView
    @IBOutlet weak var passwordStrengthView: PasswordStrengthLevelView!

    // Protocol PasswordStrengthErrorMessageView
    @IBOutlet weak var passwordStrengthErrorMessageView: UIView!
    @IBOutlet weak var passwordStrengthErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordStrengthErrorMessageViewHeightConstraint: NSLayoutConstraint!

    // Protocol PasswordErrorMessageView
    @IBOutlet weak var repeatPasswordErrorMessageView: UIView!
    @IBOutlet weak var repeatPasswordErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var repeatPasswordErrorMessageViewHeightConstraint: NSLayoutConstraint!


    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSettingsDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        scrollViewBase  =   self.scrollView
        
        // Create PickerViewManager
        pickerViewManager                   =   MSMPickerViewManager.init(frame: self.view.frame)

        // Count view height
        onePhoneViewHeight                  =   UIScreen.main.bounds.height / ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667.0 : 375) * 40.0
        
        // Add Tap Gesture Regognizer
        didAddTapGestureRecognizer()

        // Set User fields
        textFieldsCollection[0].text        =   userApp?.firstName
        textFieldsCollection[1].text        =   userApp?.lastName
        textFieldsCollection[2].text        =   userApp?.email
        
////        textFieldsCollection[0].text        =   userApp?.password
////        textFieldsCollection[0].isEnabled   =   false
        
        // Hide email error message view
        emailErrorMessageViewHeightConstraint.constant              =   Config.Constants.errorMessageViewHeight
        didHide(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)

        // Add New Phones View
        phoneViewDidAdd()
        
        
        
        
        
        
        // Hide passwords error message view
////        passwordErrorMessageViewHeightConstraint.constant           =   Config.Constants.errorMessageViewHeight
////        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
////
////        passwordStrengthErrorMessageViewHeightConstraint.constant   =   Config.Constants.errorMessageViewHeight
////        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
////
////        repeatPasswordErrorMessageViewHeightConstraint.constant     =   Config.Constants.errorMessageViewHeight
////        didHide(repeatPasswordErrorMessageView, withConstraint: repeatPasswordErrorMessageViewTopConstraint)
        
        textFieldManager.textFieldsArray = textFieldsCollection
    }
    
    func phoneViewDidAdd() {
        phonesCount += 1
        
        phonesViewHeightConstraint.constant = onePhoneViewHeight * CGFloat(phonesCount)
        phonesView.layoutIfNeeded()

        let newPhoneView = NewPhoneView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: CGFloat(phonesCount - 1) * onePhoneViewHeight),
                                                                size: CGSize.init(width: phonesView.frame.width, height: onePhoneViewHeight)))
        
        phonesView.addSubview(newPhoneView)
        dottedBorderViewsCollection.append(newPhoneView.dottedBorderView)
        
//        newPhoneView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set properties to all collections
        phoneLastTag += 1
        newPhoneView.tag = phoneLastTag

        // Add Layouts
//        if (phoneLastTag == 3) {
//            newPhoneView.topAnchor.constraint(equalTo: phonesView.topAnchor, constant: 0).isActive = true
//            newPhoneView.backgroundColor = UIColor.blue
//        } else {
//            phoneViewsCollection.last!.bottomAnchor.constraint(equalTo: phonesView.bottomAnchor, constant: 0).isActive  = false
//            phoneViewsCollection.last!.bottomAnchor.constraint(equalTo: newPhoneView.topAnchor, constant: 0).isActive = true
//            newPhoneView.backgroundColor = UIColor.orange
//        }
//
//        newPhoneView.bottomAnchor.constraint(equalTo: phonesView.bottomAnchor, constant: 0).isActive = true
//        newPhoneView.leftAnchor.constraint(equalTo: phonesView.leftAnchor, constant: 0).isActive = true
//        newPhoneView.rightAnchor.constraint(equalTo: phonesView.rightAnchor, constant: 0).isActive = true
        
        
        phonesView.layoutIfNeeded()
        phonesView.setNeedsLayout()
        phonesView.setNeedsDisplay()
        
        // Append new elements to all collections
        phoneViewsCollection.append(newPhoneView)
        textFieldsCollection.append(newPhoneView.phoneTextField)
        deleteButtonsCollection.append(newPhoneView.deleteButton)
        newPhoneView.deleteButton.isHidden = true

        // Protocol PhoneErrorMessageView
        phoneErrorMessageViewsCollection.append(newPhoneView.errorMessageView)
        phoneErrorMessageViewTopConstraintsCollection.append(newPhoneView.errorMessageViewTopConstraint)
        phoneErrorMessageViewHeightConstraintsCollection.append(newPhoneView.errorMessageViewHeightConstraint)
        
        // Hide phones error message view
        newPhoneView.errorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        newPhoneView.errorMessageView.didShow(false, withConstraint: newPhoneView.errorMessageViewTopConstraint)

        textFieldManager.textFieldsArray = textFieldsCollection
        
        UIView.animate(withDuration: 0.5, animations: {
            newPhoneView.alpha = 1
        })
        
        // Handler Delete Button Tap
        newPhoneView.handlerDeleteButtonCompletion      =   { _ in
            if (self.phoneViewsCollection.count > 1) {
                self.phoneViewDidDelete(newPhoneView)
            }
        }
    }
    
    func phoneViewDidDelete(_ phoneView: NewPhoneView) {
        let phoneViewIndex      =   self.phoneViewsCollection.index(of: phoneView)!

        phoneView.removeFromSuperview()
        phoneViewsCollection.remove(at: phoneViewIndex)
        textFieldsCollection.remove(at: phoneViewIndex)
        deleteButtonsCollection.remove(at: phoneViewIndex)
        dottedBorderViewsCollection.remove(at: phoneViewIndex)
        
        textFieldManager.textFieldsArray            =   textFieldsCollection
        phonesCount                                 -=  1
        self.phonesViewHeightConstraint.constant    +=   self.onePhoneViewHeight * CGFloat(self.phonesCount)
    }
    
    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
////        changePasswordButton.tag    =   0
        

        // Portrait
//        if newCollection.containsTraits(in: UITraitCollection(verticalSizeClass: .regular)) {
//            onePhoneViewHeight              =   UIScreen.main.bounds.height / 667.0 * 40.0
//        } else {
//            onePhoneViewHeight              =   UIScreen.main.bounds.width / 375.0 * 40.0
//        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
        handlerPassDataCompletion!(sender)
    }
    
    @IBAction func handlerSaveButtonTap(_ sender: FillVeryLightOrangeButton) {
        guard textFieldsCollection[0].text == userApp?.password else {
            didShow(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
            
            return
        }
        
        handlerSaveButtonCompletion!(parametersForAPI!)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        handlerCancelButtonCompletion!()
    }
    
    @IBAction func handlerChangeButtonTap(_ sender: UbuntuLightItalicDarkCyanButton) {
        var oldPassword: String!
        sender.tag          =   (sender.tag == 1) ? 0 : 1
        
        if (sender.tag == 1) {
            oldPassword     =   textFieldsCollection[0].text
        }
        
        UIView.animate(withDuration: 1.9, animations: {
            self.passwordsViewHeightConstraint.constant =   self.view.heightRatio * ((sender.tag == 1) ? 120.0 : 0.0)
            
            self.passwordsView.layoutIfNeeded()
        }, completion: { success in
            self.textFieldsCollection[0].isEnabled  =   (sender.tag == 1) ? true : false
            
///            if (sender.tag == 1) {
///                self.textFieldsCollection[0].becomeFirstResponder()
///            } else {
///                self.textFieldsCollection[0].resignFirstResponder()
///            }
            
            guard sender.tag == 0 && self.textFieldsCollection[0].text != nil && self.textFieldsCollection[1].text != nil && self.textFieldsCollection[2].text != nil else {
                self.textFieldsCollection[0].text   =   oldPassword
                
                return
            }
        })
    }
}
