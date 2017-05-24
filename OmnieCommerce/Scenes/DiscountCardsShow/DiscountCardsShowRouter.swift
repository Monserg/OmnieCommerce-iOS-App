//
//  DiscountCardsShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol DiscountCardsShowRouterInput {
    func navigateToDiscountCardShowScene(withDiscountCardID discountCardID: String?)
}

class DiscountCardsShowRouter: DiscountCardsShowRouterInput {
    // MARK: - Properties
    weak var viewController: DiscountCardsShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToDiscountCardShowScene(withDiscountCardID discountCardID: String?) {
        func navigateToOrganizationShowScene(withOrganizationID organizationID: String) {
            let storyboard = UIStoryboard(name: "DiscountCardShow", bundle: nil)
            let discountCardShowVC = storyboard.instantiateViewController(withIdentifier: "DiscountCardShowVC") as! DiscountCardShowViewController
            discountCardShowVC.discountCardID = discountCardID
            
            viewController.navigationController?.pushViewController(discountCardShowVC, animated: true)
        }
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
