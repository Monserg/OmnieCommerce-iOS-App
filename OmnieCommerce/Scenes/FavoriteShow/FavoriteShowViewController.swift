//
//  FavoriteShowViewController.swift
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
protocol FavoriteShowViewControllerInput {
    func displaySomething(viewModel: FavoriteShow.Something.ViewModel)
}

protocol FavoriteShowViewControllerOutput {
    func doSomething(request: FavoriteShow.Something.Request)
}

class FavoriteShowViewController: BaseViewController, FavoriteShowViewControllerInput {
    // MARK: - Properties
    var output: FavoriteShowViewControllerOutput!
    var router: FavoriteShowRouter!
    
    @IBOutlet weak var favoriteTopBarView: TopBarView!
    
    
    // MARK: - Class initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FavoriteShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        // NOTE: Ask the Interactor to do some work
        let request = FavoriteShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: FavoriteShow.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
