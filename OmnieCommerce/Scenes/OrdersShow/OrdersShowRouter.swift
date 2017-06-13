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
    func navigateToOrderCalendarShowScene(withOrdersDates ordersDates: [Date])
    func navigateToOrderShowScene(withOrderID orderID: String)
}

class OrdersShowRouter: OrdersShowRouterInput {
    // MARK: - Properties
    weak var viewController: OrdersShowViewController!
    
    
    // MARK: - Custom Functions. Navigation
    func navigateToOrderShowScene(withOrderID orderID: String) {
        let storyboard = UIStoryboard(name: "OrderShow", bundle: nil)
        let orderShowVC = storyboard.instantiateViewController(withIdentifier: "OrderShowVC") as! OrderShowViewController
        orderShowVC.orderID = orderID
        
        viewController.navigationController?.pushViewController(orderShowVC, animated: true)
    }
    
    func navigateToOrderCalendarShowScene(withOrdersDates ordersDates: [Date]) {
        let storyboard = UIStoryboard(name: "OrderCalendarShow", bundle: nil)
        let orderCalendarShowVC = storyboard.instantiateViewController(withIdentifier: "OrderCalendarShowVC") as! OrderCalendarShowViewController
        orderCalendarShowVC.allOrdersDatesByStatus = ordersDates
        
        viewController.navigationController?.pushViewController(orderCalendarShowVC, animated: true)
        
        // Handler select new date completion
        orderCalendarShowVC.handlerSelectDatesPeriodCompletion = { datesPeriod in
            if let selectedPeriod = datesPeriod as? (startDate: Date, endDate: Date?) {
                if (selectedPeriod.endDate == nil) {
                    self.viewController.selectedPeriod = (startDate: selectedPeriod.startDate, endDate: selectedPeriod.startDate)
                    self.viewController.titleLabelDidUploadWithSelectedDate()
                } else {
                    self.viewController.selectedPeriod = selectedPeriod
                    self.viewController.titleLabelDidUploadWithSelectedPeriod()
                }
            }
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
