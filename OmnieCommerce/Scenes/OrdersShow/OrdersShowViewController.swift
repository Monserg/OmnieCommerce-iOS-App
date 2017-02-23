//
//  OrdersShowViewController.swift
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
protocol OrdersShowViewControllerInput {
    func displaySomething(viewModel: OrdersShow.Something.ViewModel)
}

protocol OrdersShowViewControllerOutput {
    func doSomething(request: OrdersShow.Something.Request)
}

class OrdersShowViewController: BaseViewController, OrdersShowViewControllerInput {
    // MARK: - Properties
    var output: OrdersShowViewControllerOutput!
    var router: OrdersShowRouter!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!


    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        OrdersShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type = "ParentSearch"
        topBarViewStyle = .Small
        setup(topBarView: smallTopBarView)

        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = OrdersShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: OrdersShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
}
