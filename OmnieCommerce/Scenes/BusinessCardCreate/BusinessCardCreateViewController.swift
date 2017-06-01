//
//  BusinessCardCreateViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Kingfisher

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol BusinessCardCreateViewControllerInput {
    func businessCardDidShowCreate(fromViewModel viewModel: BusinessCardCreateModels.Item.ViewModel)
    func businessCardImageDidShowUpload(fromViewModel viewModel: BusinessCardCreateModels.Image.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol BusinessCardCreateViewControllerOutput {
    func businessCardDidCreate(withRequestModel requestModel: BusinessCardCreateModels.Item.RequestModel)
    func businessCardImageDidUpload(withRequestModel requestModel: BusinessCardCreateModels.Image.RequestModel)
}

class BusinessCardCreateViewController: BaseViewController, EmailErrorMessageView, PhoneErrorMessageView {
    // MARK: - Properties
    var interactor: BusinessCardCreateViewControllerOutput!
    var router: BusinessCardCreateRouter!
    
    var businessCardID: String?
    var phones = [String]()
    var freePhoneTags = [ 21, 22, 23, 24 ]

    var availableToEditTextFieldsCount: Int! {
        set {}
        
        get {
            let visiblePhoneViews = phoneViewsCollection.filter({ $0.isHidden == false })
            var count: Int = 1
            
            for phoneView in visiblePhoneViews {
                if let phoneTextField = textFieldsCollection.first(where: { $0.tag == phoneView.tag }), (phoneTextField.text?.isEmpty)! {
                    count += 1
                }
            }
            
            return count
        }
    }
    
    var imageID: String? {
        didSet {
            let title = (self.imageID == nil) ? "Add business card photo" : "Change business card photo"
            self.imageButton.setTitle(title, for: .normal)
            self.imageButton.setNeedsDisplay()
        }
    }
    
    var textFieldManager: MSMTextFieldManager! {
        didSet {
            // Delegates
            for textField in textFieldsCollection {
                textField.delegate = textFieldManager
            }
        }
    }

    // Outlets
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet var modalView: ModalView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var textFieldsCollection: [CustomTextField]!
    @IBOutlet var phoneViewsCollection: [UIView]!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var handbookCheckButton: DLRadioButton! {
        didSet {
            handbookCheckButton.setTitle("Add to handbook".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var imageButton: UbuntuLightVeryLightOrangeButton! {
        didSet {
            imageButton.setTitle("Add business card photo", for: .normal)
        }
    }
    
    @IBOutlet var dottedBorderViewsCollection: [DottedBorderView]! {
        didSet {
            _ = dottedBorderViewsCollection.map{ $0.style = .BottomDottedLine }
        }
    }
    
    @IBOutlet var phoneErrorMessageViewsCollection: [ErrorMessageView]!
    @IBOutlet var phoneErrorMessageViewHeightConstraintsCollection: [NSLayoutConstraint]!
    @IBOutlet var phoneErrorMessageViewTopConstraintsCollection: [NSLayoutConstraint]!
    @IBOutlet var phoneDeleteButtonsCollection: [FillColorButton]!
    @IBOutlet var phoneViewTopConstraintsCollection: [NSLayoutConstraint]!
    @IBOutlet weak var infoStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phonesViewHeightConstraint: NSLayoutConstraint!
    
    // Protocol PhoneErrorMessageView
    var phoneErrorMessageView: ErrorMessageView!
    var phoneErrorMessageViewTopConstraint: NSLayoutConstraint!
    var phoneErrorMessageViewHeightConstraint: NSLayoutConstraint!

    // Protocol EmailErrorMessageView
    @IBOutlet weak var emailErrorMessageView: ErrorMessageView! {
        didSet {
            emailErrorMessageView.handlerHiddenCompletion = { isHidden in }
        }
    }
    
    @IBOutlet weak var emailErrorMessageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailErrorMessageViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BusinessCardCreateConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (blackoutView != nil) {
            modalView?.center = blackoutView!.center
        }
        
        if (spinner.isAnimating) {
            spinner.center = view.center
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Hide email error message view
        emailErrorMessageViewHeightConstraint.constant = Config.Constants.errorMessageViewHeight
        emailErrorMessageView.didShow(false, withConstraint: emailErrorMessageViewTopConstraint)

        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        scrollViewBase = scrollView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        didAddTapGestureRecognizer()
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        // Create MSMTextFieldManager
        textFieldManager = MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC = self
        
        // Handler Phone number lenght
        textFieldManager.handlerPhoneNumberLenghtCompletion = { lenght in
            let tag = self.textFieldManager.firstResponder.tag
            let phoneDeleteButton = self.phoneDeleteButtonsCollection.first(where: { $0.tag == tag })!
            phoneDeleteButton.isHidden = ((lenght as! Int) > 0) ? false : true
            
            if ((lenght as! Int) > 0) {
                if let nextTag = self.freePhoneTags.sorted().first, self.availableToEditTextFieldsCount <= 1 {
                    self.phoneViewDidPrepareToShow(nextTag, isShow: true)
                }
            }
        }
        
        // Hide Phone Error Message View
        _ = phoneErrorMessageViewsCollection.map({
            $0.handlerHiddenCompletion = { isHidden in
                self.print(object: isHidden as! Bool)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.infoStackViewHeightConstraint.constant += (isHidden as! Bool) ?    -Config.Constants.errorMessageViewHeight :
                                                                                            Config.Constants.errorMessageViewHeight
                    
                    self.phonesViewHeightConstraint.constant = CGFloat(44.0 * Double(self.phoneViewsCollection.filter({ $0.isHidden == false }).count))
                    self.view.layoutIfNeeded()
                })
            }
        })
        
        // Handler enter validation phone number
        textFieldManager.handlerTextFieldCompletion = { (textField, success) in
            if (success) {
                self.phones.append(textField.text!)
            }
        }
        
        // Handler tags
        textFieldManager.handlerKeywordsFieldCompletion = { textField in }
        
        // Handler become first responder
        textFieldManager.handlerFirstResponderCompletion = { _ in
            self.phoneErrorMessageView = self.phoneErrorMessageViewsCollection.first(where: { $0.tag == self.textFieldManager.firstResponder.tag })
            let index = self.phoneErrorMessageViewsCollection.index(of: self.phoneErrorMessageView)
            self.phoneErrorMessageViewTopConstraint = self.phoneErrorMessageViewTopConstraintsCollection[index!]
            self.phoneErrorMessageViewHeightConstraint = self.phoneErrorMessageViewHeightConstraintsCollection[index!]
            
            // Show Add phone button
            if let text = self.textFieldManager.firstResponder.text, self.textFieldManager.firstResponder.checkPhoneValidation(text), self.freePhoneTags.count == 4 {
                self.phoneDeleteButtonsCollection[index!].isHidden = false
                self.phoneDeleteButtonsCollection[index!].titleText = "+"
            }
        }
        
        _ = phoneErrorMessageViewHeightConstraintsCollection.map({ $0.constant = Config.Constants.errorMessageViewHeight })
        phoneErrorMessageView = phoneErrorMessageViewsCollection.first
        phoneErrorMessageViewTopConstraint = phoneErrorMessageViewTopConstraintsCollection.first
        phoneErrorMessageViewHeightConstraint = phoneErrorMessageViewHeightConstraintsCollection.first
        
        for (index, phoneErrorMessageView) in phoneErrorMessageViewsCollection.enumerated() {
            phoneErrorMessageView.didShow(false, withConstraint: phoneErrorMessageViewTopConstraintsCollection[index])
        }
        
        // Edit mode
        if (businessCardID != nil) {
            if let businessCard = CoreDataManager.instance.entityBy("BusinessCard", andCodeID: businessCardID!) as? BusinessCard {
                textFieldsCollection.first?.text = businessCard.name
                textFieldsCollection.last?.text = businessCard.comment
                _ = textFieldsCollection.first(where: { $0.tag == 30 }).map{ $0.text = businessCard.email }
                
                // Show discount card photo
                if let photoImageID = businessCard.imageID, !photoImageID.isEmpty {
                    self.imageView.kf.setImage(with: ImageResource(downloadURL: photoImageID.convertToURL(withSize: .Medium, inMode: .Get), cacheKey: photoImageID),
                                                    placeholder: nil,
                                                    options: [.transition(ImageTransition.fade(1)),
                                                              .processor(ResizingImageProcessor(referenceSize: self.imageView.frame.size,
                                                                                                mode: .aspectFill))],
                                                    completionHandler: { image, error, cacheType, imageURL in
                                                        self.imageView.kf.cancelDownloadTask()
                                                        self.imageID = photoImageID
                    })
                } else {
                    self.imageView.contentMode = .center
                    self.imageView.backgroundColor = UIColor.init(hexString: "#273745")
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.imageView.image = UIImage.init(named: "image-no-card")
                    })
                }
            
                // Phones
                if let phones = businessCard.phones, phones.count > 0 {
                    _ = textFieldsCollection.first(where: { $0.tag == 20 }).map{ $0.text = phones.first }

                    if (phones.count > 1) {
                        for index in 1...phones.count - 1 {
                            _ = textFieldsCollection.first(where: { $0.tag == (20 + index) }).map({ $0.text = phones[index]; $0.isHidden = false })
                            _ = phoneViewsCollection.filter({ $0.tag == (20 + index) }).map({ $0.isHidden = false })
                            
                            if let tagIndex = self.freePhoneTags.index(of: 20 + index) {
                                self.freePhoneTags.remove(at: tagIndex)
                            }
                        }
                    }
                }
            }
        }

        phonesViewHeightConstraint.constant = CGFloat(44.0 * Double(phoneViewsCollection.filter({ $0.isHidden == false }).count))
        infoStackViewHeightConstraint.constant = ((view.frame.width > view.frame.height) ? 221.0 : 356.0) - 44.0 + phonesViewHeightConstraint.constant
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: { _ in
            self.infoStackView.isHidden = false
            self.actionStackView.isHidden = false
        })
    }
    
    func handlerResult(fromImagePicker imagePickerController: MSMImagePickerController, forAvatarButton avatarButton: UIButton) {
        // Handler Success Select Image
        imagePickerController.handlerImagePickerControllerCompletion = { image in
            if (isNetworkAvailable) {
                // Upload Image API
                self.spinnerDidStart(self.blackoutView!)
                
                let imageUploadRequestModel = BusinessCardCreateModels.Image.RequestModel(image: image)
                self.interactor.businessCardImageDidUpload(withRequestModel: imageUploadRequestModel)
            }
        }
        
        // Handler Cancel result
        imagePickerController.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
        }
    }
    
    func modalViewDidShow(withHeight height: CGFloat, andQuestion isQuestion: Bool) {
        guard isNetworkAvailable else {
            self.alertViewDidShow(withTitle: "Info", andMessage: "Disconnected from Network", completion: { _ in })
            
            return
        }

        var popupView: CustomView!

        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
        } else {
            view.bringSubview(toFront: blackoutView!)
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: 150.0)
        
        if (isQuestion) {
            popupView = ConfirmQuestionView.init(inView: modalView!, withText: "BusinessСard add?")

            // Handler Save button tap
            popupView.handlerSaveButtonCompletion = { _ in
                self.spinnerDidStart(self.view)
                self.view.endEditing(true)
                
                let name = self.textFieldsCollection.filter({ $0.tag == 10 }).first?.text ?? ""
                let email = self.textFieldsCollection.filter({ $0.tag == 30 }).first?.text ?? ""
                let comment = self.textFieldsCollection.filter({ $0.tag == 99 }).first?.text ?? ""
                
                let bodyParameters: [String: Any] = [
                    "name"      :   name,
                    "email"     :   email,
                    "phones"    :   self.phones.filter({ !$0.isEmpty }),
                    "comment"   :   comment,
                    "imageId"   :   self.imageID ?? ""
                ]
                
                let businessCardRequestModel = BusinessCardCreateModels.Item.RequestModel(parameters: bodyParameters)
                self.interactor.businessCardDidCreate(withRequestModel: businessCardRequestModel)
            }
        } else {
            popupView = ConfirmSaveView.init(inView: modalView!, withText: "BusinessСard create message")
        }
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func phoneViewDidPrepareToShow(_ tag: Int, isShow: Bool) {
        let index = phoneViewsCollection.index(where: { $0.tag == tag })
        
        guard index != nil else {
            return
        }
        
        let phoneView = phoneViewsCollection[index!]
        let phoneViewTopConstraint = phoneViewTopConstraintsCollection[index!]
        
        if (phoneView.isHidden == false && isShow) {
            return
        }
        
        if (phones.count >= 1) {
            phoneView.didShow(isShow, withConstraint: phoneViewTopConstraint)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.infoStackViewHeightConstraint.constant += (isShow) ? 44.0 : -44.0
                _ = self.phoneViewsCollection.filter({ $0.tag == tag }).map({ $0.isHidden = !isShow })
                _ = self.textFieldsCollection.filter({ $0.tag == tag }).map({ $0.isHidden = !isShow })
                _ = self.phoneDeleteButtonsCollection.filter({ $0.tag == tag }).map({ $0.titleText = "-" })
                self.phonesViewHeightConstraint.constant = CGFloat(44.0 * Double(self.phoneViewsCollection.filter({ $0.isHidden == false }).count))
                self.view.layoutIfNeeded()
                
                if let tagIndex = self.freePhoneTags.index(of: tag) {
                    self.freePhoneTags.remove(at: tagIndex)
                }
            })
        }
        
        if (phones.count == 0 && isShow) {
            phoneView.didShow(isShow, withConstraint: phoneViewTopConstraint)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.infoStackViewHeightConstraint.constant += 44.0
                _ = self.phoneViewsCollection.filter({ $0.tag == tag }).map({ $0.isHidden = false })
                _ = self.textFieldsCollection.filter({ $0.tag == tag }).map({ $0.isHidden = false })
                _ = self.phoneDeleteButtonsCollection.filter({ $0.tag == 20 }).map({ $0.titleText = "-" })
                _ = self.phoneDeleteButtonsCollection.filter({ $0.tag == tag }).map({ $0.titleText = "-" })
                self.phonesViewHeightConstraint.constant = CGFloat(44.0 * Double(self.phoneViewsCollection.filter({ $0.isHidden == false }).count))
                self.view.layoutIfNeeded()
                
                if let tagIndex = self.freePhoneTags.index(of: tag) {
                    self.freePhoneTags.remove(at: tagIndex)
                }
            })
        }
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        
        _ = dottedBorderViewsCollection.map({ $0.setNeedsDisplay() })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.phonesViewHeightConstraint.constant = CGFloat(44.0 * Double(self.phoneViewsCollection.filter({ $0.isHidden == false }).count))
            self.infoStackViewHeightConstraint.constant = CGFloat(44.0 * 3 + 45.0) + self.phonesViewHeightConstraint.constant + ((size.width > size.height) ? 0.0 : self.imageButton.frame.height)
            
            self.view.layoutIfNeeded()
        })
    }
    
    
    // MARK: - Actions
    @IBAction func handlerImageButtonTap(_ sender: UIButton) {
        self.blackoutView = MSMBlackoutView.init(inView: self.view)
        
        self.blackoutView!.didShow()
        
        let avatarActionView = AvatarActionView.init(inView: self.view)
        
        if (sender.currentImage == nil) {
            avatarActionView.deletePhotoButton.isHidden = true
        }
        
        // Handler AvatarActionView completions
        avatarActionView.handlerViewDismissCompletion = { actionType in
            switch actionType {
            // Handler Photo Make button tap
            case .PhotoUpload:
                let imagePickerController = MSMImagePickerController()
                imagePickerController.modalPresentationStyle = .overCurrentContext
                imagePickerController.photoDidLoadFromAlbum()
                
                self.present(imagePickerController, animated: true, completion: nil)
                
                // Handler MSMImagePickerController results
                self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: sender)
                
            case .PhotoMake:
                let imagePickerController = MSMImagePickerController()
                imagePickerController.modalPresentationStyle = .overCurrentContext
                
                guard imagePickerController.photoDidMakeWithCamera() else {
                    self.alertViewDidShow(withTitle: "Error", andMessage: "Camera is not available", completion: { _ in })
                    self.blackoutView!.didHide()
                    return
                }
                
                self.present(imagePickerController, animated: true, completion: nil)
                
                // Handler MSMImagePickerController results
                self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: sender)
                
            case .PhotoDelete:
                UIView.animate(withDuration: 0.7, animations: {
                    sender.setImage(UIImage.init(named: "image-no-user"), for: .normal)
                }, completion: { success in
                    appUser.imageID = nil
                    CoreDataManager.instance.didSaveContext()
                    self.blackoutView!.didHide()
                })
            }
        }
        
        
        // Handler AvatarActionView Cancel button tap
        avatarActionView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
        }
    }
    
    @IBAction func handlerSaveButtonTap(_ sender: FillVeryLightOrangeButton) {
        if (textFieldManager.checkTextFieldCollection()) {
            modalViewDidShow(withHeight: 150.0, andQuestion: true)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func handlerPhoneDeleteButtonTap(_ sender: FillColorButton) {
        view.endEditing(true)
        
        // Add/delete phone field
        if (sender.titleText == "+") {
            if let nextTag = freePhoneTags.sorted().first {
                phoneViewDidPrepareToShow(nextTag, isShow: true)
                textFieldManager.firstResponder = textFieldsCollection.first(where: { $0.tag == nextTag })
                freePhoneTags.remove(at: freePhoneTags.index(of: nextTag)!)
            }
        } else {
            phoneViewDidPrepareToShow(sender.tag, isShow: false)
            textFieldManager.firstResponder = textFieldsCollection.first(where: { $0.tag == sender.tag })
            
            if let phoneNumber = textFieldManager.firstResponder.text, let index = phones.index(of: phoneNumber), phones.count > 1 {
                _ = phones.remove(at: index)
                freePhoneTags.append(sender.tag)
                _ = self.textFieldsCollection.first(where: { $0.text == phoneNumber }).map({ $0.text = nil; $0.isHidden = true })
            }
        }
    }
    
    @IBAction func handlerHandbookCheckButtonTap(_ sender: DLRadioButton) {
        sender.tag = (sender.tag == 0) ? 1 : 0
        
        if (sender.tag == 1) {
            sender.isSelected = true
        } else {
            sender.isSelected = false
        }

        // TODO: - ADD API
    }
}


// MARK: - BusinessCardCreateViewControllerInput
extension BusinessCardCreateViewController: BusinessCardCreateViewControllerInput {
    func businessCardDidShowCreate(fromViewModel viewModel: BusinessCardCreateModels.Item.ViewModel) {
        spinnerDidFinish()
        
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { })
            
            return
        }
        
        // Show success modal view
        modalViewDidShow(withHeight: 185.0, andQuestion: false)
    }
    
    func businessCardImageDidShowUpload(fromViewModel viewModel: BusinessCardCreateModels.Image.ViewModel) {
        self.spinnerDidFinish()

        // Check for errors
        guard viewModel.responseAPI != nil else {
            self.alertViewDidShow(withTitle: "Info", andMessage: "RESPONSE_NIL", completion: { })
            return
        }
        
        guard viewModel.responseAPI!.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.responseAPI!.status, completion: { })
            return
        }
        
        // Change Avatar Button Image
        if let imageCodeID = viewModel.responseAPI?.body as? String, !imageCodeID.isEmpty {
            self.imageView.kf.setImage(with: ImageResource(downloadURL: imageCodeID.convertToURL(withSize: .Medium, inMode: .Get), cacheKey: imageCodeID),
                                       placeholder: nil,
                                       options: [.transition(ImageTransition.fade(1)),
                                                 .processor(ResizingImageProcessor(referenceSize: self.imageButton.frame.size,
                                                                                   mode: .aspectFill))],
                                       completionHandler: { image, error, cacheType, imageURL in
                                        self.imageView.kf.cancelDownloadTask()
                                        self.imageID = imageCodeID
            })
        } else {
            imageView.contentMode = .center
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.backgroundColor = UIColor.init(hexString: "#273745")
                self.imageView.image = UIImage.init(named: "image-no-card")
            })
        }
        
        self.blackoutView!.didHide()
    }
}
