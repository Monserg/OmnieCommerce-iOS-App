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
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    
//    // MARK: - Actions
//    @IBAction func handlerAvatarButtonTap(_ sender: CustomButton) {
//        view.endEditing(true)
//        
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
    
}
