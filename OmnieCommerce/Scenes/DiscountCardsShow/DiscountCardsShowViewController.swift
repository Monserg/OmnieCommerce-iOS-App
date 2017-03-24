//
//  DiscountCardsShowViewController.swift
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
protocol DiscountCardsShowViewControllerInput {
    func displaySomething(viewModel: DiscountCardsShow.Something.ViewModel)
}

protocol DiscountCardsShowViewControllerOutput {
    func doSomething(request: DiscountCardsShow.Something.Request)
}

class DiscountCardsShowViewController: BaseViewController {
    // MARK: - Properties
    var output: DiscountCardsShowViewControllerOutput!
    var router: DiscountCardsShowRouter!
    
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DiscountCardsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    

    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // Config smallTopBarView
        navigationBarView       =   smallTopBarView
        smallTopBarView.type    =   "ParentSearch"
        haveMenuItem            =   true
        
        // Load data
        let requestModel = DiscountCardsShow.Something.Request()
        output.doSomething(request: requestModel)
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
}


// MARK: - DiscountCardsShowViewControllerInput
extension DiscountCardsShowViewController: DiscountCardsShowViewControllerInput {
    func displaySomething(viewModel: DiscountCardsShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
