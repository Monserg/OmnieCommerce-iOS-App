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
            
            // Hnadler tap on Avatar photo
            cell.handlerAvatarTapCompletion = { cellAvatar in
                // Create & show action view
                let avatarActionView = AvatarActionView.init(frame: CGRect.init(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
                avatarActionView.alpha = 0                
                (UIApplication.shared.delegate as! AppDelegate).window!.addSubview(avatarActionView)
                
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                    avatarActionView.alpha = 1
                }, completion: { (success) in
                    // Handler tap on cancel button in AvatarActionView
                    avatarActionView.handlerCancelButtonTapComplition = { _ in
                        UIView.animate(withDuration: 0.7, animations: {
                            avatarActionView.alpha = 0
                        }, completion: { (success) in
                            avatarActionView.removeFromSuperview()
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
