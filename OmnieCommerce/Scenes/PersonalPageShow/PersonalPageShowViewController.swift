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
import AlamofireImage

// MARK: - Input protocols for current ViewController component VIP-cicle
protocol PersonalPageShowViewControllerInput {
    func userAppDataDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Data.ViewModel)
    func userAppDataDidShowUpdate(fromViewModel viewModel: PersonalPageShowModels.Data.ViewModel)
    func userAppTemplatesDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol PersonalPageShowViewControllerOutput {
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel)
    func userAppDataDidUpdate(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel)
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
        
        spinnerDidStart()
        
        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "Parent"
        haveMenuItem            =   true
                
        // Container Child Views
        personalDataVC = UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalDataVC") as? PersonalDataViewController
        
        // Handler avatar button tap
        personalDataVC?.handlerPassDataCompletion = { sender in
            self.blackoutView = MSMBlackoutView.init(inView: self.view)
            
            self.blackoutView!.didShow()

            let avatarButton = sender as! CustomButton
            self.avatarActionView = AvatarActionView.init(inView: self.view)
            
            // Handler AvatarActionView completions
            self.avatarActionView!.handlerViewDismissCompletion = { actionType in
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoUpload:
                        let imagePickerController   =   MSMImagePickerController()
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
                        self.print(object: "delete ok")
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
        let loadRequestModel = PersonalPageShowModels.Data.RequestModel()
        self.interactor.userAppDataDidLoad(withRequestModel: loadRequestModel)
    }
    
    func handlerResult(fromImagePicker imagePickerController: MSMImagePickerController, forAvatarButton avatarButton: CustomButton) {
        // Handler success image
        imagePickerController.handlerImagePickerControllerCompletion = { image in
            UIView.animate(withDuration: 0.5, animations: {
                avatarButton.setImage(image.af_imageAspectScaled(toFill: avatarButton.frame.size), for: .normal)
            }, completion: { success in
                self.blackoutView!.didHide()
            })
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
    func userAppDataDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Data.ViewModel) {
        spinnerDidFinish()

        // Check Network state
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
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

        // TODO: ADD HERE GET TEMPLATES REQUEST
        let templatesRequestModel = PersonalPageShowModels.Templates.RequestModel(userID: "01") // self.userApp!.codeID!)
        self.interactor.userAppTemplatesDidLoad(withRequestModel: templatesRequestModel)
    }
    
    func userAppDataDidShowUpdate(fromViewModel viewModel: PersonalPageShowModels.Data.ViewModel) {
        spinnerDidFinish()

        //        self.activeViewController?.userApp = viewModel.userApp
        router.navigateToCategoriesShowScene()
    }
    
    func userAppTemplatesDidShowLoad(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel) {
        spinnerDidFinish()
        
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            return
        }
        
        personalTemplatesVC!.organizations = viewModel.organizations        
    }
}
