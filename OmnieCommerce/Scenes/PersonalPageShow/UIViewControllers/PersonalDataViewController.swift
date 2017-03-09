//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalDataViewController: BaseViewController, EmailErrorMessageView, PasswordErrorMessageView {
    // MARK: - Properties
    var parametersForAPI = [String: String]()

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
    
    @IBOutlet var textFieldsCollection: [CustomTextField]!

    @IBOutlet var radioButtonsCollection: [DLRadioButton]! {
        didSet {
            radioButtonsCollection!.first!.isSelected   =   (userApp!.gender == 1) ? false : true
            radioButtonsCollection!.last!.isSelected    =   (userApp!.gender == 1) ? true : false
        }
    }
    
    @IBOutlet weak var passwordsViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: UIView!
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!

    // Protocol PasswordErrorMessageView
    @IBOutlet weak var passwordErrorMessageView: UIView!
    @IBOutlet weak var passwordErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordErrorMessageViewHeightConstraint: NSLayoutConstraint!


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
        
        didAddTapGestureRecognizer()
        
        // Set User fields
        textFieldsCollection[0].text        =   userApp?.firstName
        textFieldsCollection[1].text        =   userApp?.lastName
        textFieldsCollection[2].text        =   userApp?.email
        
//        textFieldsCollection[0].text        =   userApp?.password
//        textFieldsCollection[0].isEnabled   =   false
        
        // Create MSMTextFieldManager
        textFieldManager                    =   MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC          =   self
        
        // Hide email error message view
        emailErrorMessageViewHeightConstraint.constant      =   Config.Constants.errorMessageViewHeight
        didHide(emailErrorMessageView, withConstraint: emailErrorMessageViewTopConstraint)

        // Hide email error message view
        passwordErrorMessageViewHeightConstraint.constant   =   Config.Constants.errorMessageViewHeight
        didHide(passwordErrorMessageView, withConstraint: passwordErrorMessageViewTopConstraint)

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
        
        handlerSaveButtonCompletion!(parametersForAPI)
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
            let heightRatio = ((UIApplication.shared.statusBarOrientation.isPortrait) ? 494 : 216) / self.view.frame.height
            self.passwordsViewHeightConstraint.constant = heightRatio * ((sender.tag == 1) ? 84.0 : 0.0)
            
            self.passwordsView.layoutIfNeeded()
        }, completion: { success in
            self.textFieldsCollection[0].isEnabled  =   (sender.tag == 1) ? true : false
            
            if (sender.tag == 1) {
                self.textFieldsCollection[0].becomeFirstResponder()
            } else {
                self.textFieldsCollection[0].resignFirstResponder()
            }
            
            guard sender.tag == 0 && self.textFieldsCollection[0].text != nil && self.textFieldsCollection[1].text != nil && self.textFieldsCollection[2].text != nil else {
                self.textFieldsCollection[0].text   =   oldPassword
                
                return
            }
        })
    }
}
