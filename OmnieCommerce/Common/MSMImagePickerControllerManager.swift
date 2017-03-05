//
//  MSMImagePickerControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMImagePickerControllerManager: BaseViewController  {
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
