//
//  MSMImagePickerController.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMImagePickerController: UIImagePickerController {
    // MARK: - Properties
    var handlerImagePickerControllerCompletion: HandlerImagePickerControllerCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Custom Functions
    func photoDidLoadFromAlbum() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            sourceType      =   UIImagePickerControllerSourceType.photoLibrary
            allowsEditing   =   true
            delegate        =   self
        }
    }
    
    func photoDidMakeWithCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sourceType      =   UIImagePickerControllerSourceType.camera
            allowsEditing   =   false
            delegate        =   self
            
            return true
        } else {
            return false
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension MSMImagePickerController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage     =   info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        
        handlerImagePickerControllerCompletion!(chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        handlerCancelButtonCompletion!()
    }
}


// MARK: - UINavigationControllerDelegate
extension MSMImagePickerController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UINavigationBar.appearance().isTranslucent          =   false
        UIApplication.shared.statusBarStyle                 =   .lightContent
        UINavigationBar.appearance().barTintColor           =   UIColor.darkCyan
        UINavigationBar.appearance().tintColor              =   UIColor.veryLightGray

        UINavigationBar.appearance().titleTextAttributes    =   [NSFontAttributeName: UIFont.helveticaNeueCyrLight32,
                                                                 NSForegroundColorAttributeName: UIColor.veryLightGray]
    }
}
