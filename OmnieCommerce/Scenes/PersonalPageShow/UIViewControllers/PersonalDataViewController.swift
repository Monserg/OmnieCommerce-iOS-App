//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalDataViewController: BaseViewController, EmailErrorMessageView, PhoneErrorMessageView, PasswordErrorMessageView, PasswordStrengthView, PasswordStrengthErrorMessageView, RepeatPasswordErrorMessageView {
    // MARK: - Properties
    var parametersForAPI: [String: Any]?
    
    var pickerViewManager: MSMPickerViewManager! {
        didSet {
            guard birthdayPickerView != nil else {
                return
            }
            
            birthdayPickerView.delegate = self.pickerViewManager
            birthdayPickerView.dataSource = self.pickerViewManager

            let currentDayComponents = Calendar.current.dateComponents(in: TimeZone.current, from: userApp!.birthday as! Date)
            self.pickerViewManager.selectedMonthIndex = pickerViewManager.months.index(where: { $0 == String(currentDayComponents.month!) })!
            let currentDaysInMonth = pickerViewManager.days[self.pickerViewManager.selectedMonthIndex]
            self.pickerViewManager.selectedDayIndex = currentDaysInMonth.index(where: { $0 == String(currentDayComponents.day!) })!
            self.pickerViewManager.selectedYearIndex = pickerViewManager.years.index(where: { $0 == String(currentDayComponents.year!) })!
            
            birthdayPickerView.selectRow(self.pickerViewManager.selectedDayIndex, inComponent: 0, animated: true)
            birthdayPickerView.selectRow(self.pickerViewManager.selectedMonthIndex, inComponent: 2, animated: true)
            birthdayPickerView.selectRow(self.pickerViewManager.selectedYearIndex, inComponent: 4, animated: true)
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
    @IBOutlet weak var passwordsView: UIView!
    @IBOutlet weak var changePasswordButton: UbuntuLightItalicDarkCyanButton!
    @IBOutlet weak var birthdayPickerView: UIPickerView!
    @IBOutlet weak var oldPasswordChangeButton: UbuntuLightItalicDarkCyanButton!
    
    @IBOutlet weak var avatarButton: CustomButton! {
        didSet {
            guard CoreDataManager.instance.appUser.imagePath != nil else {
                return
            }
            
            // Get User Image by URL            
            self.avatarButton.imageView!.kf.indicatorType = .activity

            self.avatarButton.kf.setImage(with: URL(string: CoreDataManager.instance.appUser.imagePath!)!,
                                          for: .normal,
                                          placeholder: UIImage.init(named: "image-no-user"),
                                          options: [.transition(ImageTransition.fade(0.3))],
                                          completionHandler: { image, error, cacheType, imageURL in
                                              self.avatarButton.imageView!.kf.cancelDownloadTask()
            })
        }
    }

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
            textFieldsCollection[3].text = "Test password"
            textFieldsCollection[3].isEnabled = false
            textFieldsCollection[3].clearButtonMode = .never
            
            // Handler Check New & Repeat Passwords Values
            textFieldManager.handlerPassDataCompletion = { textField in
                guard self.textFieldsCollection[4].text == self.textFieldsCollection[5].text else {
                    self.didShow(self.repeatPasswordErrorMessageView, withConstraint: self.repeatPasswordErrorMessageViewTopConstraint)
                    return
                }
            }
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

    // Protocol RepeatPasswordErrorMessageView
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
        passwordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)

        passwordStrengthErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(passwordStrengthErrorMessageView, withConstraint: passwordStrengthErrorMessageViewTopConstraint)

        repeatPasswordErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        didHide(repeatPasswordErrorMessageView, withConstraint: repeatPasswordErrorMessageViewTopConstraint)
    }

    
    // MARK: - Transition
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        changePasswordButton.tag = 0
    }
    
    
    // MARK: - Actions
    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
        handlerPassDataCompletion!(sender)
    }
    
    @IBAction func handlerSaveButtonTap(_ sender: FillVeryLightOrangeButton) {
        parametersForAPI =  [
                                "firstName": textFieldsCollection[0].text!,
                                "surName": textFieldsCollection[1].text!,
                                "birthDay": pickerViewManager.selectedDateDidShow(),
                                "sex": radioButtonsCollection[0].isSelected ? 1 : 0,
                                "familyStatus": userApp!.familyStatus,
                                "hasChildren": userApp!.hasChildren,
                                "hasPat": userApp!.hasPet,
                                "userPhone": textFieldsCollection[3].text!
                            ]
        
        handlerSaveButtonCompletion!(parametersForAPI!)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        handlerCancelButtonCompletion!()
    }
    
    @IBAction func handlerChangeButtonTap(_ sender: UbuntuLightItalicDarkCyanButton) {
        sender.tag = (sender.tag == 1) ? 0 : 1

        UIView.animate(withDuration: 1.9, animations: {
            self.passwordsViewHeightConstraint.constant = self.view.heightRatio * ((sender.tag == 1) ? 120.0 : 0.0)
            self.passwordsView.layoutIfNeeded()
        }, completion: { success in
            self.textFieldsCollection[3].isEnabled = (sender.tag == 1) ? true : false
            
            if (sender.tag == 1) {
                self.textFieldsCollection[3].becomeFirstResponder()
                self.textFieldsCollection[3].text = nil
            } else {
                self.textFieldsCollection[3].resignFirstResponder()
            }
            
            if (sender.tag == 0 && ((self.textFieldsCollection[3].text?.isEmpty)! || (self.textFieldsCollection[4].text?.isEmpty)! || (self.textFieldsCollection[5].text?.isEmpty)!)) {
                self.textFieldsCollection[3].text = "Test password"
                self.didHide(self.passwordErrorMessageView, withConstraint: self.passwordErrorMessageViewTopConstraint)
            }
            
        })
    }
    
    @IBAction func handlerRadioButtonTap(_ sender: DLRadioButton) {
        view.endEditing(true)
        
        if (oldPasswordChangeButton.tag == 1) {
            self.textFieldsCollection[3].text = "Test password"
        }
    }
}
