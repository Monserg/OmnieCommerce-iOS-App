//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

typealias ParametersForAPI = [Any]

class PersonalDataViewController: BaseViewController, EmailErrorMessageView, PhoneErrorMessageView, PasswordErrorMessageView, PasswordStrengthView, PasswordStrengthErrorMessageView, RepeatPasswordErrorMessageView {
    // MARK: - Properties
    var profileParameters: [String: Any]?
    var passwordParameters: [String: Any]?
    var parametersForAPI: ParametersForAPI?
    
    var pickerViewManager: MSMPickerViewManager! {
        didSet {
            guard birthdayPickerView != nil else {
                return
            }
            
            birthdayPickerView.delegate = self.pickerViewManager
            birthdayPickerView.dataSource = self.pickerViewManager

            let currentDayComponents = Calendar.current.dateComponents(in: TimeZone.current,
                                                                       from: (CoreDataManager.instance.appUser.codeID == "200") ? CoreDataManager.instance.appUser!.birthday as! Date : Date())
            self.pickerViewManager.selectedMonthIndex = pickerViewManager.months.index(where: { $0 == String(currentDayComponents.month!) })!
            let currentDaysInMonth = pickerViewManager.days[self.pickerViewManager.selectedMonthIndex]
            self.pickerViewManager.selectedDayIndex = currentDaysInMonth.index(where: { $0 == String(currentDayComponents.day!) })!
            self.pickerViewManager.selectedYearIndex = pickerViewManager.years.index(where: { $0 == String(currentDayComponents.year!) })!
            
            birthdayPickerView.selectRow(self.pickerViewManager.selectedDayIndex, inComponent: 0, animated: true)
            birthdayPickerView.selectRow(self.pickerViewManager.selectedMonthIndex, inComponent: 2, animated: true)
            birthdayPickerView.selectRow(self.pickerViewManager.selectedYearIndex, inComponent: 4, animated: true)
        }
    }
    
    var handlerSaveButtonCompletion: HandlerPassDataCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    var handlerChangeNetworkStateCompletion: HandlerPassDataCompletion?
    var handlerChangeEmailCompletion: HandlerPassDataCompletion?
    
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
    @IBOutlet weak var emailsView: UIView!
    
    @IBOutlet weak var avatarButton: CustomButton! {
        didSet {
            guard CoreDataManager.instance.appUser.imagePath != nil else {
                avatarButton.setImage(UIImage.init(named: "image-no-user"), for: .normal)
                return
            }
            
            // Set User Image by URL
            self.avatarButton.kf.setImage(with: ImageResource(downloadURL: URL(string: CoreDataManager.instance.appUser.imagePath!)!, cacheKey: "userImage"),
                                          for: .normal,
                                          placeholder: UIImage.init(named: "image-no-user"),
                                          options: [.transition(ImageTransition.fade(1))],
                                          completionHandler: { image, error, cacheType, imageURL in
                                              self.avatarButton.imageView!.kf.cancelDownloadTask()
            })
        }
    }

    @IBOutlet weak var emailTextField: CustomTextField! {
        didSet {
            if (CoreDataManager.instance.appUser.codeID == "200") {
                self.emailTextField.text = CoreDataManager.instance.appUser!.email
            } else {
                let dictionary = NSKeyedUnarchiver.unarchiveObject(with: CoreDataManager.instance.appUser!.additionalData! as Data) as! [String : Any]
                self.emailTextField.text = dictionary["userEmail"] as? String
            }
        }
    }
    
    @IBOutlet var textFieldsCollection: [CustomTextField]! {
        didSet {
            textFieldManager = MSMTextFieldManager(withTextFields: textFieldsCollection)
            textFieldManager.currentVC = self
            
            textFieldsCollection[0].text = CoreDataManager.instance.appUser!.firstName
            textFieldsCollection[1].text = CoreDataManager.instance.appUser!.surName
            textFieldsCollection[2].clearButtonMode = .never
            textFieldsCollection[3].text = CoreDataManager.instance.appUser!.phone
            textFieldsCollection[4].text = "Test password"
            textFieldsCollection[4].isEnabled = false
            textFieldsCollection[4].clearButtonMode = .never
            
            // Handler Check New & Repeat Passwords Values
            textFieldManager.handlerCleanReturnCompletion = { textField in
                guard self.textFieldsCollection[5].text == self.textFieldsCollection[6].text else {
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
            radioButtonsCollection!.first!.isSelected = (CoreDataManager.instance.appUser!.gender == 1) ? false : true
            radioButtonsCollection!.last!.isSelected = (CoreDataManager.instance.appUser!.gender == 1) ? true : false
        }
    }
    
    @IBOutlet weak var passwordsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailsViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: ErrorMessageView! {
        didSet {
            emailErrorMessageView.handlerHiddenCompletion = { isHidden in
                UIView.animate(withDuration: 0.5, animations: {
                    if (self.emailErrorMessageView.isHidden && !(isHidden as! Bool)) {
                        self.emailsViewHeightConstraint.constant += 14.0
                    }

                    if (!self.emailErrorMessageView.isHidden && (isHidden as! Bool)) {
                        self.emailsViewHeightConstraint.constant -= 14.0
                    }

                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol PhoneErrorMessageView
    @IBOutlet weak var phoneErrorMessageView: ErrorMessageView! {
        didSet {
            phoneErrorMessageView.handlerHiddenCompletion = { isHidden in
                self.print(object: isHidden as! Bool)
            }
        }
    }
    
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
        
        // Handler Change Network Connection State
        self.handlerChangeNetworkConnectionStateCompletion = { success in
            self.handlerChangeNetworkStateCompletion!(success as! Bool)
        }
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
        emailsViewHeightConstraint.constant = view.heightRatio * 40.0
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
        profileParameters =         [
                                        "firstName": textFieldsCollection[0].text!,
                                        "surName": textFieldsCollection[1].text!,
                                        "birthDay": pickerViewManager.selectedDateDidShow(),
                                        "sex": radioButtonsCollection[0].isSelected ? 1 : 0,
                                        "familyStatus": CoreDataManager.instance.appUser!.familyStatus,
                                        "hasChildren": CoreDataManager.instance.appUser!.hasChildren,
                                        "hasPet": CoreDataManager.instance.appUser!.hasPet,
                                        "userPhone": textFieldsCollection[3].text!
                                    ]
        
        parametersForAPI = [ParametersForAPI]()
        parametersForAPI!.append(profileParameters!)

        if (!(self.textFieldsCollection.last!.text?.isEmpty)!) {
            passwordParameters =    [
                                        "newPassword": self.textFieldsCollection.last!.text!
                                    ]
            
            parametersForAPI!.append(passwordParameters!)
        }
        
        handlerSaveButtonCompletion!(parametersForAPI!)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        handlerCancelButtonCompletion!()
    }
    
    @IBAction func handlerChangePasswordButtonTap(_ sender: UbuntuLightItalicDarkCyanButton) {
        sender.tag = (sender.tag == 1) ? 0 : 1

        UIView.animate(withDuration: 0.5, animations: {
            self.passwordsViewHeightConstraint.constant = self.view.heightRatio * ((sender.tag == 1) ? 138.0 : 40.0)
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.textFieldsCollection[4].isEnabled = (sender.tag == 1) ? true : false
            
            if (sender.tag == 1) {
                self.textFieldsCollection[4].becomeFirstResponder()
                self.textFieldsCollection[4].text = nil
            } else {
                self.textFieldsCollection[4].resignFirstResponder()
            }
            
            if (sender.tag == 0 && ((self.textFieldsCollection[4].text?.isEmpty)! || (self.textFieldsCollection[5].text?.isEmpty)! || (self.textFieldsCollection[6].text?.isEmpty)!)) {
                self.textFieldsCollection[4].text = "Test password"
                self.view.endEditing(true)
            }
        })
    }
    
    @IBAction func handlerRadioButtonTap(_ sender: DLRadioButton) {
        view.endEditing(true)
        
        if (oldPasswordChangeButton.tag == 1) {
            self.textFieldsCollection[4].text = "Test password"
        }
    }
    
    @IBAction func handlerChangeEmailButtonTap(_ sender: UbuntuLightItalicDarkCyanButton) {
        sender.tag = (sender.tag == 1) ? 0 : 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.emailsViewHeightConstraint.constant = self.view.heightRatio * ((sender.tag == 1) ? 80.0 : 40.0)
            self.view.layoutIfNeeded()
        }, completion: { success in
            if (sender.tag == 1) {
                self.textFieldsCollection[2].becomeFirstResponder()
                self.textFieldsCollection[2].text = nil
            } else {
                self.textFieldsCollection[2].resignFirstResponder()
            }
        })
    }
    
    @IBAction func handlerSaveNewEmailButtonTap(_ sender: UbuntuLightItalicDarkCyanButton) {
        if (textFieldsCollection[2].checkEmailValidation(textFieldsCollection[2].text!)) {
            handlerChangeEmailCompletion!(textFieldsCollection[2].text!)
        } else {
            didShow(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)
        }
    }
}
