//
//  FavoriteOrganizationsShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol FavoriteOrganizationsShowRouterInput {
    func navigateToOrganizationShowScene(_ organization: Organization)
    func navigateToSomewhere()
}

class FavoriteOrganizationsShowRouter: FavoriteOrganizationsShowRouterInput {
    // MARK: - Properties
    weak var viewController: FavoriteOrganizationsShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToOrganizationShowScene(_ organization: Organization) {
        let storyboard                          =   UIStoryboard(name: "OrganizationShow", bundle: nil)
        let organizationShowVC                  =   storyboard.instantiateViewController(withIdentifier: "OrganizationShowVC") as! OrganizationShowViewController
        organizationShowVC.organization         =   organization
        
        viewController.navigationController?.pushViewController(organizationShowVC, animated: true)
    }

    func navigateToSomewhere() {
        // NOTE: Teach the router how to navigate to another scene. Some examples follow:
        // 1. Trigger a storyboard segue
        // viewController.performSegueWithIdentifier("ShowSomewhereScene", sender: nil)
        
        // 2. Present another view controller programmatically
        // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)
        
        // 3. Ask the navigation controller to push another view controller onto the stack
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
        
        // 4. Present a view controller from a different storyboard
        // let storyboard = UIStoryboard(name: "OtherThanMain", bundle: nil)
        // let someWhereViewController = storyboard.instantiateInitialViewController() as! SomeWhereViewController
        // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    }
    
    // Communication
    func passDataToNextScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router which scenes it can communicate with
        if segue.identifier == "ShowSomewhereScene" {
            passDataToSomewhereScene(segue: segue)
        }
    }
    
    // Transition
    func passDataToSomewhereScene(segue: UIStoryboardSegue) {
        // NOTE: Teach the router how to pass data to the next scene
        // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
        // someWhereViewController.output.name = viewController.output.name
    }
}
