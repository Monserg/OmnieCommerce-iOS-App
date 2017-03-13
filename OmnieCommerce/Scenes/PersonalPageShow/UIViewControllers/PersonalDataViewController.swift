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
    let phonesCount: Int    =   1
    var phoneLastTag: Int   =   0

    var pickerViewManager: MSMPickerViewManager! {
        didSet {
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
    
    @IBOutlet weak var birthdayPickerView: UIPickerView! {
        didSet {}
    }
    
    @IBOutlet var textFieldsCollection: [CustomTextField]! {
        didSet {
            textFieldManager            =   MSMTextFieldManager(withTextFields: textFieldsCollection)
            textFieldManager.currentVC  =   self
            
            _ = textFieldsCollection.map({ textField in
                // PhoneButton style
                if (textField.style! == .PhoneButton) {
                    // Handler Delete Button tap
                    self.textFieldManager.handlerTextFieldCompletion    =   { (phoneButtonTextField, success) in
                        self.print(object: "\(phoneButtonTextField, success)")
                        
                        _       =   self.deleteButtonsCollection.filter({ $0.tag == phoneButtonTextField.tag }).map{ $0.isHidden = success }
                    }
                    
                    // Handler add new phone field
                    if (textField.text?.characters.count == 3) {
                        self.textFieldManager.handlerPassDataCompletion =   { phoneButtonTextField in
//                            _   =   self.phonesStackViewsCollection.filter{ $0.tag == textField.tag }.map{ $0.isHidden = false }
                        }
                    }

                    // Handler Error Message
                    self.textFieldManager.handlerPassDataCompletion     =   { phoneButtonTextField in
                        let phoneErrorView          =   self.phoneErrorMessageViewsCollection.first(where: { $0.tag == (phoneButtonTextField as! CustomTextField).tag })!
                        let phoneErrorViewIndex     =   self.phoneErrorMessageViewsCollection.index(of: phoneErrorView)!
                        
                        UIView.animate(withDuration: 1.9, animations: {
                            self.phonesViewHeightConstraint.constant =   self.view.heightRatio * CGFloat(40 * self.phonesCount + 154)
                            
                            self.phonesView.layoutIfNeeded()
                        }, completion: { success in
                            self.didShow(phoneErrorView, withConstraint: self.phoneErrorMessageViewTopConstraintsCollection[phoneErrorViewIndex])
                        })
                    }
                }
            })
        }
    }
    
    @IBOutlet var deleteButtonsCollection: [FillVeryLightOrangeButton]! {
        didSet {
            _ = deleteButtonsCollection.map{ $0.isHidden = true }
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

    // Protocol PhoneErrorMessageView
    @IBOutlet var phoneErrorMessageViewsCollection: [UIView]!
    @IBOutlet var phoneErrorMessageViewTopConstraintsCollection: [NSLayoutConstraint]!
    @IBOutlet var phoneErrorMessageViewHeightConstraintsCollection: [NSLayoutConstraint]!
    
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

        // Add Tap Gesture Regognizer
        didAddTapGestureRecognizer()

        // Set User fields
        textFieldsCollection[0].text        =   userApp?.firstName
        textFieldsCollection[1].text        =   userApp?.lastName
        textFieldsCollection[2].text        =   userApp?.email
        
//        textFieldsCollection[0].text        =   userApp?.password
//        textFieldsCollection[0].isEnabled   =   false
        
        // Hide email error message view
        emailErrorMessageViewHeightConstraint.constant              =   Config.Constants.errorMessageViewHeight
        didHide(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)

        // Hide phones error message view
        _   =   phoneErrorMessageViewHeightConstraintsCollection.map{ $0.constant  =   Config.Constants.errorMessageViewHeight }
        _   =   phoneErrorMessageViewsCollection.enumerated().map{ didHide($1, withConstraint: phoneErrorMessageViewTopConstraintsCollection[$0]) }
        
        phonesView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(40 * phonesCount) / 494.0).isActive = true

        // Hide passwords error message view
        passwordErrorMessageViewHeightConstraint.constant           =   Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
        
        passwordStrengthErrorMessageViewHeightConstraint.constant   =   Config.Constants.errorMessageViewHeight
        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
        
        repeatPasswordErrorMessageViewHeightConstraint.constant     =   Config.Constants.errorMessageViewHeight
        didHide(repeatPasswordErrorMessageView, withConstraint: repeatPasswordErrorMessageViewTopConstraint)
    }
    
    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        changePasswordButton.tag    =   0
        
//        phonesView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(40 * phonesCount) / 216.0).isActive = true
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
            
//            if (sender.tag == 1) {
//                self.textFieldsCollection[0].becomeFirstResponder()
//            } else {
//                self.textFieldsCollection[0].resignFirstResponder()
//            }
            
            guard sender.tag == 0 && self.textFieldsCollection[0].text != nil && self.textFieldsCollection[1].text != nil && self.textFieldsCollection[2].text != nil else {
                self.textFieldsCollection[0].text   =   oldPassword
                
                return
            }
        })
    }
    
    @IBAction func handlerDeletePhoneButtonTap(_ sender: FillVeryLightOrangeButton) {
    
    }
}
