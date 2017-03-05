//
//  AvatarTableViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire

class AvatarTableViewCell: UITableViewCell {
    // MARK: - Properties
    weak var imagePickerControllerManager: MSMImagePickerControllerManager?

    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerNewViewControllerShowCompletion: HandlerNewViewControllerShowCompletion?

    @IBOutlet weak var actionButton: CustomButton!
 
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    deinit {
        print(object: "\(type(of: self)) deinit")
    }

    
    // MARK: - Actions
    @IBAction func handlerActionButtonTap(_ sender: CustomButton) {
        // Create & show action view
        let avatarActionView                =   AvatarActionView.init(frame: CGRect.init(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
        avatarActionView.alpha              =   0
        
        let window                          =   (UIApplication.shared.delegate as! AppDelegate).window!
        window.addSubview(avatarActionView)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            avatarActionView.alpha          =   1
        }, completion: { (success) in
            // Handler action buttons from AvatarActionView
            avatarActionView.handlerDismissViewComplition = { actionType in
                UIView.animate(withDuration: 0.7, animations: {
                    avatarActionView.alpha  =   0
                }, completion: { (success) in
                    avatarActionView.removeFromSuperview()
                    
                    self.imagePickerControllerManager   =   MSMImagePickerControllerManager()
                    
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoMake:
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imagePicker             =   UIImagePickerController()
                            imagePicker.sourceType      =   UIImagePickerControllerSourceType.camera
                            imagePicker.allowsEditing   =   false
                            imagePicker.delegate        =   self.imagePickerControllerManager
                            
                            self.handlerNewViewControllerShowCompletion!(imagePicker)

                            // Handler Successfull result
                            self.imagePickerControllerManager?.handlerImagePickerControllerCompletion   =   { image in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.actionButton.setImage(image, for: .normal)
                                }, completion: { success in
                                    self.handlerSendButtonCompletion!()
                                })
                            }
                        }
                        
                    // Handler Photo Upload button tap
                    case .PhotoUpload:
                        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                            let imagePicker             =   UIImagePickerController()
                            imagePicker.sourceType      =   UIImagePickerControllerSourceType.photoLibrary
                            imagePicker.allowsEditing   =   true
                            imagePicker.delegate        =   self.imagePickerControllerManager
                            
                            self.handlerNewViewControllerShowCompletion!(imagePicker)

                            // Handler Successfull result
                            self.imagePickerControllerManager?.handlerImagePickerControllerCompletion   =   { image in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.actionButton.setImage(image, for: .normal)
                                }, completion: { success in
                                    self.handlerSendButtonCompletion!()
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
        })
    }
}


// MARK: - ConfigureCell
extension AvatarTableViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        if let userApp = item as? AppUser {
            if (userApp.imagePath != nil) {
                Alamofire.request(userApp.imagePath!).responseImage { response in
                    if let image = response.result.value {
                        self.actionButton.setImage(image, for: .normal)
                        self.actionButton.imageView!.contentMode     =   .scaleAspectFit
                    }
                }
            }
        }
    }
}
