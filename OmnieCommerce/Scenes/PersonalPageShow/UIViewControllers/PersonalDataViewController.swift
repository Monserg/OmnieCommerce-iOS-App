//
//  PersonalDataViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 30.01.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class PersonalDataViewController: UIViewController {
    // MARK: - Properties
    var actionView: AvatarActionView?
    var cellAvatar: AvatarTableViewCell?
    
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        didSetupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Functions
    func didSetupTableView() {
        tableView.register(UINib(nibName: PersonalPageShow.Cell.Avatar().cellIdentifier, bundle: nil), forCellReuseIdentifier: PersonalPageShow.Cell.Avatar().cellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}


// MARK: - UITableViewDataSource
extension PersonalDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Avatar
        case 0:
            return 1

        // Info
        case 1:
            return 5

        // Gender & Birthday & Password & Buttons
        case 2, 3, 5, 6:
            return 1

        // Expanded
        case 4:
            return 3

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // AvatarTableViewCell
        case 0:
            let cell: AvatarTableViewCell = PersonalPageShow.Cell.Avatar().setup(tableView: tableView)
            cellAvatar = cell
            
            // Handler Avatar photo tap
            cell.handlerAvatarTapCompletion = { cellAvatar in
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
                                print("delete ok")
                                
                            default:
                                break
                            }
                        })
                    }
                })
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}


// MARK: - UITableViewDelegate
extension PersonalDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 86.0
        
        default:
            return 200.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: - 
extension PersonalDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.darkCyan
        UINavigationBar.appearance().tintColor = UIColor.veryLightGray
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.veryLightGray]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        cellAvatar!.actionButton.setImage(chosenImage, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
