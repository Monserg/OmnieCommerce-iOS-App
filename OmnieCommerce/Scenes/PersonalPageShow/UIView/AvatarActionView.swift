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
}

class AvatarActionView: CustomView {
    // MARK: - Properties
    var handlerViewDismissCompletion: HandlerViewDismissCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        super.init(frame: view.frame)
        
        createFromXIB()
        
        let widthRatio          =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 375 : 667) / view.frame.width
        let heightRatio         =   ((UIApplication.shared.statusBarOrientation.isPortrait) ? 667 : 375) / view.frame.height
        self.frame              =   CGRect.init(x: 0, y: 0, width: 345 * widthRatio, height: 185 * heightRatio)
        self.alpha              =   0
        self.backgroundColor    =   UIColor.clear
        self.layer.cornerRadius =   5
        self.clipsToBounds      =   true
        
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints   =   false
        
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  =   true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  =   true
        
        self.didShow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }

    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha  =   0
        }, completion: { success in
            self.removeFromSuperview()
        })
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: AvatarActionView.self), bundle: Bundle(for: AvatarActionView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame  =   frame
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPhotoUploadButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
        handlerViewDismissCompletion!(.PhotoUpload)
        didHide()
    }
    
    @IBAction func handlerPhotoMakeButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
        handlerViewDismissCompletion!(.PhotoMake)
        didHide()
    }
    
    @IBAction func handlerPhotoDeleteButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
        handlerViewDismissCompletion!(.PhotoDelete)
        didHide()
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        handlerCancelButtonCompletion!()
        didHide()
    }
}
