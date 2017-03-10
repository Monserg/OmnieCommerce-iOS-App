//
//  SettingsShowViewController.swift
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
protocol SettingsShowViewControllerInput {
    func displaySomething(viewModel: SettingsShow.Something.ViewModel)
}

protocol SettingsShowViewControllerOutput {
    func doSomething(request: SettingsShow.Something.Request)
}

class SettingsShowViewController: BaseViewController {
    // MARK: - Properties
    var output: SettingsShowViewControllerOutput!
    var router: SettingsShowRouter!
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SettingsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
        smallTopBarView.type    =   "ParentSearch"
        topBarViewStyle         =   .Small
        setup(topBarView: smallTopBarView)
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = SettingsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
}


// MARK: - SettingsShowViewControllerInput
extension SettingsShowViewController: SettingsShowViewControllerInput {
    func displaySomething(viewModel: SettingsShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
