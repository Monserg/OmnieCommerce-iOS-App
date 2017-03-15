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
    func userAppTemplatesDidShow(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel)
    func userAppDataDidShow(fromViewModel viewModel: PersonalPageShowModels.UserApp.ViewModel)
}

// MARK: - Output protocols for Interactor component VIP-cicle
protocol PersonalPageShowViewControllerOutput {
    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel)
    func userAppDataDidUpdate(withRequestModel requestModel: PersonalPageShowModels.UserApp.RequestModel)
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
        
        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "Parent"
        haveMenuItem            =   true
                
        // Container Child Views
        personalDataVC          =   UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalDataVC") as? PersonalDataViewController
        
        // Handler avatar button tap
        personalDataVC?.handlerPassDataCompletion   =   { sender in
            self.blackoutView       =   MSMBlackoutView.init(inView: self.view)
            
            self.blackoutView!.didShow()

            let avatarButton        =   sender as! CustomButton
            self.avatarActionView   =   AvatarActionView.init(inView: self.view)
            
            // Handler AvatarActionView completions
            self.avatarActionView!.handlerViewDismissCompletion     =   { actionType in
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoUpload:
                        let imagePickerController   =   MSMImagePickerController()
                        imagePickerController.photoDidLoadFromAlbum()
                        
                        self.present(imagePickerController, animated: true, completion: nil)
                        
                        // Handler MSMImagePickerController results
                        self.handlerResult(fromImagePicker: imagePickerController, forAvatarButton: avatarButton)

                    case .PhotoMake:
                        let imagePickerController   =   MSMImagePickerController()
                        
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
            self.avatarActionView!.handlerCancelButtonCompletion     =   { _ in
                self.blackoutView!.didHide()
            }
        }
        
        // Handler Action Buttons
        personalDataVC!.handlerSaveButtonCompletion     =   { parameters in
            // TODO: - ADD API
            
            self.router.navigateToCategoriesShowScene()
        }
        
        personalDataVC!.handlerCancelButtonCompletion   =   { _ in
            self.router.navigateToCategoriesShowScene()
        }

        personalTemplatesVC     =   UIStoryboard(name: "PersonalPageShow", bundle: nil).instantiateViewController(withIdentifier: "PersonalTemplatesVC") as? PersonalTemplatesViewController
        
        activeViewController    =   personalDataVC

        viewSettingsDidLoad()        
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        setupSegmentedControlView()
        containerView.autoresizesSubviews   =   true
    }
    
    func setupSegmentedControlView() {
        self.userApp                        =   CoreDataManager.instance.appUser

        segmentedControlView.actionButtonHandlerCompletion = { sender in
            self.print(object: "\(type(of: self)): \(#function) run. Sender tag = \(sender.tag)")
            
            switch sender.tag {
            case 1:
                let requestModel            =   PersonalPageShowModels.Templates.RequestModel(userID: "01") // self.userApp!.codeID!)
                self.interactor.userAppTemplatesDidLoad(withRequestModel: requestModel)
                
            default:
                self.activeViewController   =   self.personalDataVC
            }
        }
    }
    
    func handlerResult(fromImagePicker imagePickerController: MSMImagePickerController, forAvatarButton avatarButton: CustomButton) {
        // Handler success image
        imagePickerController.handlerImagePickerControllerCompletion    =   { image in
            UIView.animate(withDuration: 0.5, animations: {
                avatarButton.setImage(image.af_imageAspectScaled(toFill: avatarButton.frame.size), for: .normal)
            }, completion: { success in
                self.blackoutView!.didHide()
            })
        }
        
        // Handler Cancel result
        imagePickerController.handlerCancelButtonCompletion     =    { _ in
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
    func userAppTemplatesDidShow(fromViewModel viewModel: PersonalPageShowModels.Templates.ViewModel) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }

        self.personalTemplatesVC!.organizations     =   viewModel.organizations
        self.activeViewController                   =   self.personalTemplatesVC
        
        self.personalTemplatesVC!.viewSettingsDidLoad()
    }

    func userAppDataDidShow(fromViewModel viewModel: PersonalPageShowModels.UserApp.ViewModel) {
        guard isNetworkAvailable else {
            alertViewDidShow(withTitle: "Not Reachable".localized(), andMessage: "Disconnected from Network".localized())
            
            return
        }
        
        print(object: "\(type(of: self)): \(#function) run.")
        
        self.activeViewController?.userApp  =   viewModel.userApp
        
        router.navigateToCategoriesShowScene()
    }
}
