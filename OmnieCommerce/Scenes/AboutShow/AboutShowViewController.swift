//
//  AboutShowViewController.swift
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
protocol AboutShowViewControllerInput {
    func displaySomething(viewModel: AboutShow.Something.ViewModel)
}

protocol AboutShowViewControllerOutput {
    func doSomething(request: AboutShow.Something.Request)
}

class AboutShowViewController: BaseViewController, AboutShowViewControllerInput {
    // MARK: - Properties
    var output: AboutShowViewControllerOutput!
    var router: AboutShowRouter!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    
 
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        AboutShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type = "ParentSearch"
        topBarViewStyle = .Small
        setup(topBarView: smallTopBarView)
        
        initialSetupDidLoad()
    }
    

    // MARK: - Custom Functions
    func initialSetupDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = AboutShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: AboutShow.Something.ViewModel) {
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
