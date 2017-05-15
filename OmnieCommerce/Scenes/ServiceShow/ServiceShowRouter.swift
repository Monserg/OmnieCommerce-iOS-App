//
//  ServiceShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol ServiceShowRouterInput {
    func navigateToOrder(_ order: Order)
    func navigateToCalendar(_ orderDateComponents: DateComponents)
}

class ServiceShowRouter: ServiceShowRouterInput {
    // MARK: - Properties
    weak var viewController: ServiceShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToOrder(_ order: Order) {
        let storyboard = UIStoryboard(name: "OrderShow", bundle: nil)
        let orderShowVC = storyboard.instantiateViewController(withIdentifier: "OrderShowVC") as! OrderShowViewController
        orderShowVC.order = order
        
        viewController.navigationController?.pushViewController(orderShowVC, animated: true)
    }

    func navigateToCalendar(_ orderDateComponents: DateComponents) {
        let storyboard = UIStoryboard(name: "CalendarShow", bundle: nil)
        let calendarShowVC = storyboard.instantiateViewController(withIdentifier: "CalendarShowVC") as! CalendarShowViewController
        calendarShowVC.orderDateComponents = orderDateComponents
//        calendarShowVC.service = viewController.serviceProfile
        
        viewController.navigationController?.pushViewController(calendarShowVC, animated: true)
        
        // Handler Confirm completion
        calendarShowVC.handlerConfirmButtonCompletion = { newOrderDateComponents in
            self.viewController.orderDateComponents = newOrderDateComponents as? DateComponents
            self.viewController.orderDateComponentsDidShow()
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
