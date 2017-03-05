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
    
    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            // TableViewController Manager
            tableView.cellIdentifiers                               =   [(code: "AvatarTableViewCell", height: 86.0),
                                                                         (code: "ActionButtonsTableViewCell", height: 127)]
            
            tableView.tableViewControllerManager                    =   MSMTableViewControllerManager()
            tableView.tableViewControllerManager.tableView          =   self.tableView
            tableView.tableViewControllerManager.sectionsCount      =   1
            tableView.tableViewControllerManager.dataSource         =   Array(repeatElement(CoreDataManager.instance.appUser, count: tableView.cellIdentifiers.count))
            
            // Handler Save Button tap
            tableView.tableViewControllerManager.handlerSendButtonCompletion       =   { _ in
                self.handlerSaveButtonCompletion!(self.parametersForAPI)
            }
            
            // Handler Cancel Button tap
            tableView.tableViewControllerManager.handlerCancelButtonCompletion     =   { _ in
                self.handlerCancelButtonCompletion!()
            }

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
