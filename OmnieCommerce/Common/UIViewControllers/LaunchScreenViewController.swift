//
//  LaunchScreenViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 17.11.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import CoreData
import SWRevealViewController

class LaunchScreenViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blackoutView: UIView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    
    
    // MARK: - Class Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let appSettings = CoreDataManager.instance.didLoadEntity(byName: "AppSettings") as? AppSettings ?? AppSettings()
        CoreDataManager.instance.appSettings = appSettings
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Config Launch Screen
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Custom Functions
    func setup() {
        let window      =   UIApplication.shared.windows[0]
        
        // Create CoreData instance
        let appUser     =   CoreDataManager.instance.didLoadEntity(byName: "AppUser") as? AppUser ?? AppUser()
        CoreDataManager.instance.appUser        =   appUser
        
        if (appUser.isAuthorized) {
            backgroundImageView.isHidden        =   true
            backgroundImageView.backgroundColor =   UIColor.clear
            blackoutView.backgroundColor        =   UIColor.veryDarkDesaturatedBlue25Alpha94
        } else {
            backgroundImageView.image           =   (UIApplication.shared.statusBarOrientation.isPortrait) ? UIImage(named: "image-background-portrait") : UIImage(named: "image-background-landscape")
            blackoutView.isHidden               =   false
            blackoutView.backgroundColor        =   UIColor.veryDarkDesaturatedBlue25Alpha94
        }
        
        // Initial VC
        let signInShowStoryboard                =   UIStoryboard(name: "SignInShow", bundle: nil)
        let initialNC                           =   signInShowStoryboard.instantiateViewController(withIdentifier: "SignInShowNC") as! BaseNavigationController
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            window.rootViewController           =   initialNC
            window.makeKeyAndVisible()
        }
    }
}
