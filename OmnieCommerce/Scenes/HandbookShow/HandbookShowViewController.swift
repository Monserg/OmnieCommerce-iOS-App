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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
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

//        let handbookProfile = CoreDataManager.instance.entityDidLoad(byName: "Handbook", andPredicateParameters: NSPredicate.init(format: "codeID == %@", self.handbookID)) as! Handbook
        
        // Show scene
        
        // Create MSMTextFieldManager
        textFieldManager = MSMTextFieldManager(withTextFields: textFieldsCollection)
        textFieldManager.currentVC = self
        
        // Handler Phone number lenght
        textFieldManager.handlerPhoneNumberLenghtCompletion = { lenght in
            let tag = self.textFieldManager.firstResponder.tag
            let phoneDeleteButton = self.phoneDeleteButtonsCollection.first(where: { $0.tag == tag })!
            phoneDeleteButton.isHidden = ((lenght as! Int) == 4) ? false : true
        }
        
        // Hide Phone Error Message View
        _ = phoneErrorMessageViewsCollection.map({
                $0.handlerHiddenCompletion = { isHidden in
                    self.print(object: isHidden as! Bool)
                }
        })
        
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
    
    func modalViewDidShow(withHeight height: CGFloat, customSubview subView: CustomView, andValues values: [Any]?) {
        if (blackoutView == nil) {
            blackoutView = MSMBlackoutView.init(inView: view)
            blackoutView!.didShow()
        }
        
        modalView = ModalView.init(inView: blackoutView!, withHeight: height)
        let popupView = ConfirmSaveView.init(inView: modalView!, withText: "Saved message")
        
        // Handler Cancel button tap
        popupView.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
            self.blackoutView = nil
            
            self.navigationController!.popViewController(animated: true)
        }
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
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
                imagePickerController.photoDidLoadFromAlbum()
                
                self.present(imagePickerController, animated: true, completion: nil)
                
                // Handler MSMImagePickerController results
                self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: sender)
                
            case .PhotoMake:
                let imagePickerController = MSMImagePickerController()
                
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
        spinnerDidStart(view)
        
        let name = textFieldsCollection.filter({ $0.tag == 10 }).first?.text ?? ""
        
        let parameters: [String: Any] = [
                                            "name"      :   name,
                                            "address"   :   "Хмельницкий, ул. Горбанчука 6",
                                            "phones"    :   "",
                                            "tags"      :   "",
                                            "imageId"   :   imageID ?? ""
                                        ]
        
        let handbookRequestModel = HandbookShowModels.Item.RequestModel(parameters: parameters)
        interactor.handbookDidCreate(withRequestModel: handbookRequestModel)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: BorderVeryLightOrangeButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func handlerPhoneDeleteButtonTap(_ sender: FillColorButton) {

    }
}


// MARK: - HandbookShowViewControllerInput
extension HandbookShowViewController: HandbookShowViewControllerInput {
    func handbookDidShowCreate(fromViewModel viewModel: HandbookShowModels.Item.ViewModel) {
        // Check for errors
        guard viewModel.status == "SUCCESS" else {
            self.alertViewDidShow(withTitle: "Error", andMessage: viewModel.status, completion: { })
            
            return
        }
        
        // Show success modal view
        modalViewDidShow(withHeight: 185.0, customSubview: ConfirmSaveView(), andValues: nil)
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
