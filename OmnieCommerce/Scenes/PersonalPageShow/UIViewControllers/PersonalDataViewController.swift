//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalDataViewController: BaseViewController {
    // MARK: - Properties
    var parametersForAPI = [String: String]()

    var handlerSaveButtonCompletion: HandlerSaveButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    var handlerPassDataCompletion: HandlerPassDataCompletion?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarButton: CustomButton!
    
    @IBOutlet var radioButtonsCollection: [DLRadioButton]! {
        didSet {
            radioButtonsCollection!.first!.isSelected   =   (userApp!.gender == 1) ? false : true
            radioButtonsCollection!.last!.isSelected    =   (userApp!.gender == 1) ? true : false
        }
    }
    

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
    }
    
    
    // MARK: - Actions
    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
        handlerPassDataCompletion!(sender)
        

        
        
        // Create & show action view
//        let avatarActionView                =   AvatarActionView.init(frame: CGRect.init(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
//        avatarActionView.alpha              =   0
//        
//        let window                          =   (UIApplication.shared.delegate as! AppDelegate).window!
//        window.addSubview(avatarActionView)
        
//        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
//            avatarActionView.alpha          =   1
//        }, completion: { (success) in
        
        // Handler action buttons from AvatarActionView
        /*
            avatarActionView.handlerDismissViewComplition = { actionType in
                UIView.animate(withDuration: 0.7, animations: {
                    avatarActionView.alpha  =   0
                }, completion: { (success) in
                    avatarActionView.removeFromSuperview()
                    
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoMake:
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imagePickerControllerManager   =   MSMImagePickerControllerManager()
                            let imagePicker             =   UIImagePickerController()
                            imagePicker.sourceType      =   UIImagePickerControllerSourceType.camera
                            imagePicker.allowsEditing   =   false
                            imagePicker.delegate        =   imagePickerControllerManager
                            
                            self.present(imagePicker, animated: true, completion: nil)
                            
                            // Handler Successfull result
                            imagePickerControllerManager.handlerImagePickerControllerCompletion   =   { image in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.avatarButton.setImage(image, for: .normal)
                                }, completion: { success in
//                                    self.handlerSendButtonCompletion!()
                                })
                            }
                        }
                        
                    // Handler Photo Upload button tap
                    case .PhotoUpload:
                        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                            let imagePicker             =   UIImagePickerController()
                            imagePicker.sourceType      =   UIImagePickerControllerSourceType.photoLibrary
                            imagePicker.allowsEditing   =   true
                            imagePicker.delegate        =   self
                            
                            self.present(imagePicker, animated: true, completion: nil)
                            
                            // Handler Successfull result
                            self.handlerImagePickerControllerCompletion   =   { image in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.avatarButton.setImage(image.af_imageAspectScaled(toFill: self.avatarButton.frame.size), for: .normal)
                                })
                            }
                        }
                        
                    // Handler Photo Delete button tap
                    case .PhotoDelete:
                        self.print(object: "delete ok")
                        
                    default:
                        break
                    }
                })
            }
//        })
   })

    
//    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
//        view.endEditing(true)
//
 */
    }

}
