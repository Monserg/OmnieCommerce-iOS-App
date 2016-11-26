//
//  BusinessCardsShowViewController.swift
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
protocol BusinessCardsShowViewControllerInput {
    func displaySomething(viewModel: BusinessCardsShow.Something.ViewModel)
}

protocol BusinessCardsShowViewControllerOutput {
    func doSomething(request: BusinessCardsShow.Something.Request)
}

class BusinessCardsShowViewController: BaseViewController, BusinessCardsShowViewControllerInput {
    // MARK: - Properties
    var output: BusinessCardsShowViewControllerOutput!
    var router: BusinessCardsShowRouter!
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var topBarViewHeightPortraitConstraint: NSLayoutConstraint!
    
//    override var topBarViewRounding: CircleView.CirleRadius {
//        willSet {
//            if (newValue == .big) {
//                topBarViewHeightPortraitConstraint.constant = Config.Constants.topViewBarHeightBig
//            }
//        }
//    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BusinessCardsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
//        topBarViewRounding = .big
        setup(topBarView: topBarView)
        
        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = BusinessCardsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: BusinessCardsShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
