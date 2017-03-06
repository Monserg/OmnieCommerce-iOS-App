//
//  MSMImagePickerControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMImagePickerControllerManager: UIViewController  {
    // MARK: - Class Functions
    var handlerImagePickerControllerCompletion: HandlerImagePickerControllerCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
}


// MARK: - UIImagePickerControllerDelegate
extension MSMImagePickerControllerManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage     =   info[UIImagePickerControllerOriginalImage] as! UIImage
        let image           =   chosenImage
        
        dismiss(animated: true, completion: nil)
        
        handlerImagePickerControllerCompletion!(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
       
        handlerCancelButtonCompletion!()
    }
}


// MARK: - UINavigationControllerDelegate
extension MSMImagePickerControllerManager: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle                 =   .lightContent
        UINavigationBar.appearance().barTintColor           =   UIColor.veryDarkGray
        UINavigationBar.appearance().tintColor              =   UIColor.veryLightGray
        UINavigationBar.appearance().titleTextAttributes    =   [NSForegroundColorAttributeName: UIColor.veryLightGray]
        UINavigationBar.appearance().isTranslucent          =   false
    }
}
