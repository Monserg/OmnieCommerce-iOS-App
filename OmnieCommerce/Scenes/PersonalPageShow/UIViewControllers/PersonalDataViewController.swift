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

    var pickerViewManager: MSMPickerViewManager! {
        didSet {
            guard birthdayPickerView != nil else {
                return
            }
            
            birthdayPickerView.delegate = self.pickerViewManager
            birthdayPickerView.dataSource = self.pickerViewManager

            let currentDayComponents = Calendar.current.dateComponents(in: TimeZone.current, from: userApp!.birthday as! Date)
            let currentMonthIndex = pickerViewManager.months.index(where: { $0 == String(currentDayComponents.month!) })!
            let currentDaysInMonth = pickerViewManager.days[currentMonthIndex]
            let currentDayIndex = currentDaysInMonth.index(where: { $0 == String(currentDayComponents.day!) })!
            let currentYearIndex = pickerViewManager.years.index(where: { $0 == String(currentDayComponents.year!) })!
            
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
    @IBOutlet weak var changePasswordButton: UbuntuLightItalicDarkCyanButton!
    @IBOutlet weak var birthdayPickerView: UIPickerView!
    
    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            self.emailTextField.text = userApp!.email
        }
    }
    
    @IBOutlet var textFieldsCollection: [CustomTextField]! {
        didSet {
            textFieldManager = MSMTextFieldManager(withTextFields: textFieldsCollection)
            textFieldManager.currentVC = self
            
            textFieldsCollection[0].text = userApp!.firstName
            textFieldsCollection[1].text = userApp!.surName
            textFieldsCollection[2].text = userApp!.phone
            
            ////        textFieldsCollection[0].text = userApp?.password
            ////        textFieldsCollection[0].isEnabled = false
        }
    }
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map{ $0.style = .BottomDottedLine }
        }
    }
    
    @IBOutlet var radioButtonsCollection: [DLRadioButton]! {
        didSet {
            radioButtonsCollection!.first!.isSelected = (userApp!.gender == 1) ? false : true
            radioButtonsCollection!.last!.isSelected = (userApp!.gender == 1) ? true : false
        }
    }
    
    @IBOutlet weak var passwordsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: UIView!
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol PhoneErrorMessageView
    @IBOutlet weak var phoneErrorMessageView: ErrorMessageView!
    @IBOutlet weak var phoneErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneErrorMessageViewHeightConstraint: NSLayoutConstraint!

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
        scrollViewBase = self.scrollView
        
        // Create PickerViewManager
        pickerViewManager = MSMPickerViewManager.init(frame: self.view.frame)

        // Add Tap Gesture Regognizer
        didAddTapGestureRecognizer()
        
        // Hide Email Error Message View
        emailErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)

        // Hide Phone Error Message View
        phoneErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        phoneErrorMessageView.didShow(false, withConstraint: phoneErrorMessageViewTopConstraint)
        
        // Hide passwords error message view
////        passwordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
////        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)
////
////        passwordStrengthErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
////        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)
////
////        repeatPasswordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
////        didHide(repeatPasswordErrorMessageView, withConstraint: repeatPasswordErrorMessageViewTopConstraint)
        
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
////        changePasswordButton.tag = 0
        

        // Portrait
//        if newCollection.containsTraits(in: UITraitCollection(verticalSizeClass: .regular)) {
//            onePhoneViewHeight = UIScreen.main.bounds.height / 667.0 * 40.0
//        } else {
//            onePhoneViewHeight = UIScreen.main.bounds.width / 375.0 * 40.0
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
        sender.tag = (sender.tag == 1) ? 0 : 1
        
        if (sender.tag == 1) {
            oldPassword = textFieldsCollection[0].text
        }
        
        UIView.animate(withDuration: 1.9, animations: {
            self.passwordsViewHeightConstraint.constant = self.view.heightRatio * ((sender.tag == 1) ? 120.0 : 0.0)
            
            self.passwordsView.layoutIfNeeded()
        }, completion: { success in
            self.textFieldsCollection[0].isEnabled = (sender.tag == 1) ? true : false
            
///            if (sender.tag == 1) {
///                self.textFieldsCollection[0].becomeFirstResponder()
///            } else {
///                self.textFieldsCollection[0].resignFirstResponder()
///            }
            
            guard sender.tag == 0 && self.textFieldsCollection[0].text != nil && self.textFieldsCollection[1].text != nil && self.textFieldsCollection[2].text != nil else {
                self.textFieldsCollection[0].text = oldPassword
                
                return
            }
        })
    }
    
    @IBAction func handlerRadioButtonTap(_ sender: DLRadioButton) {
        view.endEditing(true)
    }
}
