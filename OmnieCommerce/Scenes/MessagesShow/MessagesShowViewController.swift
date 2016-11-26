//
//  MessagesShowViewController.swift
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
protocol MessagesShowViewControllerInput {
    func displaySomething(viewModel: MessagesShow.Something.ViewModel)
}

protocol MessagesShowViewControllerOutput {
    func doSomething(request: MessagesShow.Something.Request)
}

class MessagesShowViewController: BaseViewController, MessagesShowViewControllerInput {
    // MARK: - Properties
    var output: MessagesShowViewControllerOutput!
    var router: MessagesShowRouter!
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var topBarViewHeightPortraitConstraint: NSLayoutConstraint!
    
//    override var topBarViewRounding: String {
//        willSet {
//            if (newValue == "Big") {
//                topBarViewHeightPortraitConstraint.constant = Config.Constants.topViewBarHeightBig
//            }
//        }
//    }

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MessagesShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config topBarView
//        topBarViewRounding = "Big"
        setup(topBarView: topBarView)
        
        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = MessagesShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: MessagesShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
