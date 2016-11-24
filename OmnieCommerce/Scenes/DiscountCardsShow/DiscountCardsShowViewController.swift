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

class DiscountCardsShowViewController: BaseViewController, DiscountCardsShowViewControllerInput {
    // MARK: - Properties
    var output: DiscountCardsShowViewControllerOutput!
    var router: DiscountCardsShowRouter!
    
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

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DiscountCardsShowConfigurator.sharedInstance.configure(viewController: self)
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
        let request = DiscountCardsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: DiscountCardsShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
