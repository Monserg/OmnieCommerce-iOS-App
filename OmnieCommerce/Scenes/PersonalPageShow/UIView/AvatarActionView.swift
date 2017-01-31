//
//  AvatarActionView.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

enum ActionType: Int {
    case PhotoMake = 0
    case PhotoUpload
    case PhotoDelete
    case Cancel
}

typealias HandlerDismissViewComplition = ((_ actionType: ActionType) -> ())

class AvatarActionView: UIView {
    // MARK: - Properties
    var handlerDismissViewComplition: HandlerDismissViewComplition?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        setup()
    }
    
    
    // MARK: - Custom Functions
    func setup() {
        UINib(nibName: String(describing: AvatarActionView.self), bundle: Bundle(for: AvatarActionView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        print(object: "\(type(of: self)): \(#function) run. Initialization view.frame = \(view.frame)")
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPhotoUploadButtonTap(_ sender: CustomButton) {
        handlerDismissViewComplition!(.PhotoUpload)
    }
    
    @IBAction func handlerPhotoMakeButtonTap(_ sender: CustomButton) {
        handlerDismissViewComplition!(.PhotoMake)
    }
    
    @IBAction func handlerPhotoDeleteButtonTap(_ sender: CustomButton) {
        handlerDismissViewComplition!(.PhotoDelete)
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        handlerDismissViewComplition!(.Cancel)
    }
}
