//
//  HandbookShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Kingfisher

// MARK: - Input & Output protocols
protocol HandbookShowViewControllerInput {
    func handbookDidShowCreate(fromViewModel viewModel: HandbookShowModels.Item.ViewModel)
    func handbookImageDidShowUpload(fromViewModel viewModel: HandbookShowModels.Image.ViewModel)
}

protocol HandbookShowViewControllerOutput {
    func handbookDidCreate(withRequestModel requestModel: HandbookShowModels.Item.RequestModel)
    func handbookImageDidUpload(withRequestModel requestModel: HandbookShowModels.Image.RequestModel)
}

class HandbookShowViewController: BaseViewController, PhoneErrorMessageView {
    // MARK: - Properties
    var interactor: HandbookShowViewControllerOutput!
    var router: HandbookShowRouter!
    
    var phones = [String]()
    var keywords = [String]()
    var freePhoneTags = [ 21, 22, 23, 24 ]
    let locationManager = LocationManager()

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
            let title = (self.imageID == nil) ? "Add dictionary photo" : "Change dictionary photo"
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
    @IBOutlet weak var addressTextField: CustomTextField!
    @IBOutlet weak var addressButton: UIButton!

    @IBOutlet weak var imageButton: UbuntuLightVeryLightOrangeButton! {
        didSet {
            imageButton.setTitle("Add dictionary photo", for: .normal)
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

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        HandbookShowConfigurator.sharedInstance.configure(viewController: self)
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
        
        viewSettingsDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Start location
        if (addressTextField.text?.isEmpty)! {
            locationManager.startCoreLocation(inMode: .Current)
        } else {
            self.addressTextField.text = String(format: "%@, %@", locationManager.currentLocation.addressCity!, locationManager.currentLocation.addressStreet!)
        }
        
        // Handler Current location position
        locationManager.handlerPassCurrentLocationCompletion = { currentLocation in
            if let location = currentLocation as? LocationItem, location.addressCity != nil, location.addressStreet != nil {
                self.addressTextField.text = String(format: "%@, %@", location.addressCity!, location.addressStreet!)
                self.addressButton.isUserInteractionEnabled = true
            }
        }
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        scrollViewBase = scrollView
        smallTopBarView.type = "Child"
        haveMenuItem = false

        infoStackViewHeightConstraint.constant = (view.frame.width > view.frame.height) ? 176.0 : 311.0

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
        textFieldManager.handlerKeywordsFieldCompletion = { textField in
            self.keywords = self.textFieldsCollection.last!.text!.convertToKeywords()
        }

        // Handler become first responder
        textFieldManager.handlerFirstResponderCompletion = { _ in
            self.phoneErrorMessageView = self.phoneErrorMessageViewsCollection.first(where: { $0.tag == self.textFieldManager.firstResponder.tag })
            let index = self.phoneErrorMessageViewsCollection.index(of: self.phoneErrorMessageView)
            self.phoneErrorMessageViewTopConstraint = self.phoneErrorMessageViewTopConstraintsCollection[index!]
            self.phoneErrorMessageViewHeightConstraint = self.phoneErrorMessageViewHeightConstraintsCollection[index!]
        }
        
        _ = phoneErrorMessageViewHeightConstraintsCollection.map({ $0.constant = Config.Constants.errorMessageViewHeight })
        phoneErrorMessageView = phoneErrorMessageViewsCollection.first
        phoneErrorMessageViewTopConstraint = phoneErrorMessageViewTopConstraintsCollection.first
        phoneErrorMessageViewHeightConstraint = phoneErrorMessageViewHeightConstraintsCollection.first

        for (index, phoneErrorMessageView) in phoneErrorMessageViewsCollection.enumerated() {
            phoneErrorMessageView.didShow(false, withConstraint: phoneErrorMessageViewTopConstraintsCollection[index])
        }
    }
    
    func handlerResult(fromImagePicker imagePickerController: MSMImagePickerController, forAvatarButton avatarButton: UIButton) {
        // Handler Success Select Image
        imagePickerController.handlerImagePickerControllerCompletion = { image in
            if (isNetworkAvailable) {
                // Upload Image API
                self.spinnerDidStart(self.blackoutView!)
                
                let imageUploadRequestModel = HandbookShowModels.Image.RequestModel(image: image)
                self.interactor.handbookImageDidUpload(withRequestModel: imageUploadRequestModel)
            }
        }
        
        // Handler Cancel result
        imagePickerController.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
        }
    }
    
    func modalViewDidShow() {
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
            self.revealViewController().panGestureRecognizer().isEnabled = false
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: 185.0)
        let popupView = ConfirmSaveView.init(inView: modalView!, withText: "Dictionary saved message")
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            self.revealViewController().panGestureRecognizer().isEnabled = true
            
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
            self.infoStackViewHeightConstraint.constant = CGFloat(44.0 * 3) + self.phonesViewHeightConstraint.constant + ((size.width > size.height) ? 0.0 : self.imageButton.frame.height)
            
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
        guard isNetworkAvailable else {
            self.alertViewDidShow(withTitle: "Info", andMessage: "Disconnected from Network", completion: { _ in })
            
            return
        }

        if (textFieldManager.checkTextFieldCollection()) {
            spinnerDidStart(view)
            view.endEditing(true)
            
            let name = textFieldsCollection.filter({ $0.tag == 10 }).first?.text ?? ""
            
            let parameters: [String: Any] = [
                                                "name"      :   name,
                                                "address"   :   "Хмельницкий, ул. Горбанчука 6",
                                                "phones"    :   phones.filter({ !$0.isEmpty }),
                                                "tags"      :   keywords,
                                                "imageId"   :   imageID ?? ""
                                            ]
            
            let handbookRequestModel = HandbookShowModels.Item.RequestModel(parameters: parameters)
            interactor.handbookDidCreate(withRequestModel: handbookRequestModel)
        }
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func handlerPhoneDeleteButtonTap(_ sender: FillColorButton) {
        view.endEditing(true)
        phoneViewDidPrepareToShow(sender.tag, isShow: false)
        textFieldManager.firstResponder = textFieldsCollection.first(where: { $0.tag == sender.tag })

        if let phoneNumber = textFieldManager.firstResponder.text, let index = phones.index(of: phoneNumber), phones.count > 1 {
            _ = phones.remove(at: index)
            freePhoneTags.append(sender.tag)
            _ = self.textFieldsCollection.first(where: { $0.text == phoneNumber }).map({ $0.text = nil })
        }
    }
    
    @IBAction func handlerAddressButtonTap(_ sender: UIButton) {
        locationManager.currentLocation.name = textFieldsCollection.first?.text ?? "Zorro"
        self.router.navigateToOrganizationMapShowScene(withItems: [locationManager.currentLocation])
    }
}


// MARK: - HandbookShowViewControllerInput
extension HandbookShowViewController: HandbookShowViewControllerInput {
    func handbookDidShowCreate(fromViewModel viewModel: HandbookShowModels.Item.ViewModel) {
        spinnerDidFinish()

        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { })
            
            return
        }
        
        // Show success modal view
        modalViewDidShow()
    }
    
    func handbookImageDidShowUpload(fromViewModel viewModel: HandbookShowModels.Image.ViewModel) {
        // Check for errors
        guard viewModel.responseAPI!.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.responseAPI!.status, completion: { })
            
            return
        }

        // Change Avatar Button Image
        if let imageCodeID = viewModel.responseAPI?.body as? String, !imageCodeID.isEmpty {
            self.imageView.kf.setImage(with: ImageResource(downloadURL: imageCodeID.convertToURL(withSize: .Medium, inMode: .Get), cacheKey: imageCodeID),
                                                            placeholder: UIImage.init(named: "image-no-photo"),
                                                            options: [.transition(ImageTransition.fade(1)),
                                                                      .processor(ResizingImageProcessor(referenceSize: self.imageButton.frame.size,
                                                                                                        mode: .aspectFill))],
                                                            completionHandler: { image, error, cacheType, imageURL in
                                                                self.imageView.kf.cancelDownloadTask()
                                                                self.imageID = imageCodeID
            })
        } else {
            self.imageView.backgroundColor = UIColor.init(hexString: "#273745")
        }
        
        self.blackoutView!.didHide()
        self.spinnerDidFinish()
    }
}
