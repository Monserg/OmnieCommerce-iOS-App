//
//  CalendarShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.12.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol CalendarShowViewControllerInput {
    func displaySomething(viewModel: CalendarShow.Something.ViewModel)
}

protocol CalendarShowViewControllerOutput {
    func doSomething(request: CalendarShow.Something.Request)
}

class CalendarShowViewController: BaseViewController, CalendarShowViewControllerInput {
    // MARK: - Properties
    var output: CalendarShowViewControllerOutput!
    var router: CalendarShowRouter!
    

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CalendarShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        
        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = CalendarShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: CalendarShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        view.backgroundColor = UIColor.veryDarkDesaturatedBlue24
    }
}
