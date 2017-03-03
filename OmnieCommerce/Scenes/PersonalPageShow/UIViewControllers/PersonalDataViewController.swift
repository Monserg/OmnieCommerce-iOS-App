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
    var avatarActionView: AvatarActionView?
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        didSetupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - Custom Functions
    func didSetupView() {
        self.view.autoresizesSubviews = true

    }
    
    
    // MARK: - Actions
    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
        view.endEditing(true)
        
        // Create & show action view
        let avatarActionView = AvatarActionView.init(frame: CGRect.init(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
        avatarActionView.alpha = 0
        (UIApplication.shared.delegate as! AppDelegate).window!.addSubview(avatarActionView)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            avatarActionView.alpha = 1
        }, completion: { (success) in
            // Handler action buttons from AvatarActionView
            avatarActionView.handlerDismissViewComplition = { actionType in
                UIView.animate(withDuration: 0.7, animations: {
                    avatarActionView.alpha = 0
                }, completion: { (success) in
                    avatarActionView.removeFromSuperview()
                    
                    switch actionType {
                    // Handler Photo Make button tap
                    case .PhotoMake:
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imagePicker = UIImagePickerController()
                            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                            imagePicker.allowsEditing = false
                            imagePicker.delegate = self
                            
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                        
                    // Handler Photo Upload button tap
                    case .PhotoUpload:
                        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                            let imagePicker = UIImagePickerController()
                            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                            imagePicker.allowsEditing = true
                            imagePicker.delegate = self
                            
                            self.present(imagePicker, animated: true, completion: nil)
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


    // MARK: - GestureRecognizer
//    @IBAction func handlerTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }
}


// MARK: - 
extension PersonalDataViewController: UIImagePickerControllerDelegate {
//, UINavigationControllerDelegate {
//    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
//        UINavigationBar.appearance().barTintColor = UIColor.darkCyan
//        UINavigationBar.appearance().tintColor = UIColor.veryLightGray
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.veryLightGray]
//        UINavigationBar.appearance().isTranslucent = false
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        avatarButton.setImage(chosenImage, for: .normal)
//        
//        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
