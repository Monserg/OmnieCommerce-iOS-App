//
//  PersonalPageShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Toucan
import Kingfisher

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol PersonalPageShowViewControllerInput {
    func userAppDataDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.LoadData.ViewModel)
    func userAppDataDidShowUpload(fromViewModel viewModel: PersonalPageShowModels.UploadData.ViewModel)
    func userAppImageDidShowUpload(fromViewModel viewModel: PersonalPageShowModels.UploadImage.ViewModel)
    func userAppImageDidShowDelete(fromViewModel viewModel: PersonalPageShowModels.LoadData.ViewModel)
    func userAppTemplatesDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol PersonalPageShowViewControllerOutput {
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel)
    func userAppDataDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadData.RequestModel)
    func userAppImageDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadImage.RequestModel)
    func userAppImageDidDelete(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel)
    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel)
}

class PersonalPageShowViewController: BaseViewController {
    // MARK: - Properties
    var interactor: PersonalPageShowViewControllerOutput!
    var router: PersonalPageShowRouter!

    // Container childVC
    var animationDirection: AnimationDirection?
    var personalDataVC: PersonalDataViewController?
    var personalTemplatesVC: PersonalTemplatesViewController?
    
    var wasImageUploaded: Bool?
    weak var avatarActionView: AvatarActionView?

    var activeViewController: BaseViewController? {
        didSet {
            guard oldValue != nil else {
                router.updateActiveViewController()
                
                return
            }
            
            animationDirection = ((oldValue?.view.tag)! < (activeViewController?.view.tag)!) ? .FromRightToLeft : .FromLeftToRight
            router.removeInactiveViewController(inactiveViewController: oldValue)
        }
    }
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var containerView: CustomView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        PersonalPageShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerDidStart(nil)
        
        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "Parent"
        haveMenuItem            =   true
                
        // Container Child Views
        personalDataVC = UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalDataVC") as? PersonalDataViewController
        
        // Handler Avatar Button tap
        personalDataVC?.handlerPassDataCompletion = { sender in
            self.blackoutView = MSMBlackoutView.init(inView: self.view)
            
            self.blackoutView!.didShow()

            let avatarButton = sender as! CustomButton
            self.avatarActionView = AvatarActionView.init(inView: self.view)
            
            if ((sender as! CustomButton).currentImage == nil) {
                self.avatarActionView!.deleteButton.isHidden = true
            }
            
            // Handler AvatarActionView completions
            self.avatarActionView!.handlerViewDismissCompletion = { actionType in
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoUpload:
                        let imagePickerController = MSMImagePickerController()
                        imagePickerController.photoDidLoadFromAlbum()
                        
                        self.present(imagePickerController, animated: true, completion: nil)
                        
                        // Handler MSMImagePickerController results
                        self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: avatarButton)

                    case .PhotoMake:
                        let imagePickerController = MSMImagePickerController()
                        
                        guard imagePickerController.photoDidMakeWithCamera() else {
                            self.alertViewDidShow(withTitle: "Error".localized(), andMessage: "Camera is not available".localized())
                            self.blackoutView!.didHide()
                            return
                        }
                        
                        self.present(imagePickerController, animated: true, completion: nil)

                        // Handler MSMImagePickerController results
                        self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: avatarButton)
                        
                    case .PhotoDelete:

                        self.blackoutView!.didHide()
                    }
            }
            
                        
            // Handler AvatarActionView Cancel button tap
            self.avatarActionView!.handlerCancelButtonCompletion = { _ in
                self.blackoutView!.didHide()
            }
        }
        
        // Handler Action Buttons
        personalDataVC!.handlerSaveButtonCompletion = { parameters in
            // TODO: - ADD API
            
            self.router.navigateToCategoriesShowScene()
        }
        
        personalDataVC!.handlerCancelButtonCompletion = { _ in
            self.router.navigateToCategoriesShowScene()
        }

        personalTemplatesVC = UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalTemplatesVC") as? PersonalTemplatesViewController
        
        viewSettingsDidLoad()        
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        userAppDataDidLoad()
        setupSegmentedControlView()
        containerView.autoresizesSubviews = true
        
        // Handler Change Network State
        personalDataVC!.handlerChangeNetworkStateCompletion = { success in
            guard self.wasImageUploaded != nil else {
                return
            }
            
            if ((success as! Bool) && !self.wasImageUploaded!) {
                // Deferred Upload Image API
                self.spinnerDidStart(self.blackoutView!)
                let uploadedImage = (self.personalDataVC!.avatarButton.image(for: .normal))!
                let imageUploadRequestModel = PersonalPageShowModels.UploadImage.RequestModel(image: uploadedImage)
                self.interactor.userAppImageDidUpload(withRequestModel: imageUploadRequestModel)
            }
        }
    }
    
    func setupSegmentedControlView() {
        segmentedControlView.actionButtonHandlerCompletion = { sender in
            switch sender.tag {
            case 1:
                self.activeViewController = self.personalTemplatesVC
                
            default:
                self.activeViewController = self.personalDataVC
            }
        }
    }
    
    func userAppDataDidLoad() {
        if (isNetworkAvailable) {
            let loadRequestModel = PersonalPageShowModels.LoadData.RequestModel()
            self.interactor.userAppDataDidLoad(withRequestModel: loadRequestModel)
        } else {
            spinnerDidFinish()
            activeViewController = personalDataVC
        }
    }
    
    func handlerResult(fromImagePicker imagePickerController: MSMImagePickerController, forAvatarButton avatarButton: CustomButton) {
        // Handler Success Select Image
        imagePickerController.handlerImagePickerControllerCompletion = { image in
            let uploadedImage = Toucan(image: image)
                                .resize(avatarButton.frame.size, fitMode: Toucan.Resize.FitMode.crop)
                                .maskWithEllipse().image

            if (self.isNetworkAvailable) {
                // Upload Image API
                self.spinnerDidStart(self.blackoutView!)
                let imageUploadRequestModel = PersonalPageShowModels.UploadImage.RequestModel(image: uploadedImage)
                self.interactor.userAppImageDidUpload(withRequestModel: imageUploadRequestModel)
            } else {
                // Change Avatar Button Image
                UIView.animate(withDuration: 0.7, animations: {
                    avatarButton.setImage(uploadedImage, for: .normal)
                }, completion: { success in
                    self.wasImageUploaded = false
                    self.blackoutView!.didHide()
                })
            }
        }
        
        // Handler Cancel result
        imagePickerController.handlerCancelButtonCompletion = { _ in
            self.blackoutView!.didHide()
        }
    }
        
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
        segmentedControlView.setNeedsDisplay()
        
        if (self.activeViewController == self.personalTemplatesVC) {
            _ = self.personalTemplatesVC!.tableView.visibleCells.map{ ($0 as! UserTemplateTableViewCell).dottedBorderView.setNeedsDisplay() }
        }
    }
}


// MARK: - PersonalPageShowViewControllerInput
extension PersonalPageShowViewController: PersonalPageShowViewControllerInput {
    func userAppDataDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.LoadData.ViewModel) {
        spinnerDidFinish()

        // Check Network state
        guard isNetworkAvailable else {
            activeViewController = personalDataVC
            return
        }
        
        // Check Response value
        guard viewModel.response != nil && (viewModel.response?.code == 200 || viewModel.response?.code == 2201) else {
            if (viewModel.response?.errorMessage == nil) {
                alertViewDidShow(withTitle: "Error".localized(), andMessage: "Wrong input data".localized())
            } else {
                alertViewDidShow(withTitle: "Error".localized(), andMessage: viewModel.response!.errorMessage!)
            }
            
            activeViewController = personalDataVC
            return
        }
        
        // Mofidy AppUser properties
        CoreDataManager.instance.didSaveContext()
        
        activeViewController = personalDataVC

        // Get Templates
        let templatesRequestModel = PersonalPageShowModels.Templates.RequestModel(userID: "01") // self.userApp!.codeID!)
        self.interactor.userAppTemplatesDidLoad(withRequestModel: templatesRequestModel)
    }
    
    func userAppDataDidShowUpload(fromViewModel viewModel: PersonalPageShowModels.UploadData.ViewModel) {
        spinnerDidFinish()

        // Check Network state
        guard isNetworkAvailable else {
            activeViewController = personalDataVC
            return
        }
        
        CoreDataManager.instance.didSaveContext()
        router.navigateToCategoriesShowScene()
    }
    
    func userAppImageDidShowUpload(fromViewModel viewModel: PersonalPageShowModels.UploadImage.ViewModel) {
        spinnerDidFinish()
        
        // Check Network state
        guard isNetworkAvailable else {
            self.wasImageUploaded = false
            return
        }
        
        CoreDataManager.instance.didSaveContext()
        ImageCache.default.store(self.personalDataVC!.avatarButton.image(for: .normal)!, forKey: "userImage")
        wasImageUploaded = true
        self.blackoutView!.didHide()
    }
    
    func userAppImageDidShowDelete(fromViewModel viewModel: PersonalPageShowModels.LoadData.ViewModel) {
        spinnerDidFinish()
        
        // Check Network state
        guard isNetworkAvailable else {
            return
        }
        
        CoreDataManager.instance.didSaveContext()
        self.blackoutView!.didHide()
    }
    
    func userAppTemplatesDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel) {
        spinnerDidFinish()
        
        guard isNetworkAvailable else {
            return
        }
        
        personalTemplatesVC!.organizations = viewModel.organizations        
    }
}
