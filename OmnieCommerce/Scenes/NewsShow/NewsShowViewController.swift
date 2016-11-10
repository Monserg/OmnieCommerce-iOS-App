//
//  NewsShowViewController.swift
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
protocol NewsShowViewControllerInput {
    func displaySomething(viewModel: NewsShow.Something.ViewModel)
}

protocol NewsShowViewControllerOutput {
    func doSomething(request: NewsShow.Something.Request)
}

class NewsShowViewController: BaseViewController, NewsShowViewControllerInput {
    // MARK: - Properties
    var output: NewsShowViewControllerOutput!
    var router: NewsShowRouter!
    
    @IBOutlet weak var newsTopBarView: TopBarView!

    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(self.newsTopBarView, title: "News")

        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = NewsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: NewsShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
