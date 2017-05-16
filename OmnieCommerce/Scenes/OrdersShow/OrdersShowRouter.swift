//
//  OrdersShowRouter.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol OrdersShowRouterInput {
    func navigateToOrderShowScene(_ order: Order)
    func navigateToCalendar(withOrdersDates ordersDates: [Date]?)
}

class OrdersShowRouter: OrdersShowRouterInput {
    // MARK: - Properties
    weak var viewController: OrdersShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToOrderShowScene(_ order: Order) {
        let storyboard = UIStoryboard(name: "OrderShow", bundle: nil)
        let orderShowVC = storyboard.instantiateViewController(withIdentifier: "OrderShowVC") as! OrderShowViewController
        orderShowVC.order = order
        orderShowVC.orderMode = .Preview
        
        viewController.navigationController?.pushViewController(orderShowVC, animated: true)
    }
    
    func navigateToCalendar(withOrdersDates ordersDates: [Date]?) {
        let storyboard = UIStoryboard(name: "OrderCalendarShow", bundle: nil)
        let orderCalendarShowVC = storyboard.instantiateViewController(withIdentifier: "OrderCalendarShowVC") as! OrderCalendarShowViewController
        orderCalendarShowVC.ordersDates = ordersDates
        
        viewController.navigationController?.pushViewController(orderCalendarShowVC, animated: true)
        
        // Handler select new date completion
        orderCalendarShowVC.handlerSelectNewDateCompletion = { newDate in
            self.viewController.dateStart = (newDate as! Date).convertToString(withStyle: .DateHyphen)
            self.viewController.dateEnd = self.viewController.dateStart
            self.viewController.setupTitleLabel(withDate: newDate as! Date)
            self.viewController.viewSettingsDidLoad()
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
