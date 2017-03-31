//
//  NewsActionsShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol NewsActionsShowPresenterInput {
    func presentSomething(responseModel: NewsActionsShowModels.Something.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol NewsActionsShowPresenterOutput: class {
    func displaySomething(viewModel: NewsActionsShowModels.Something.ViewModel)
}

class NewsActionsShowPresenter: NewsActionsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: NewsActionsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func presentSomething(responseModel: NewsActionsShowModels.Something.ResponseModel) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = NewsActionsShowModels.Something.ViewModel()
        viewController.displaySomething(viewModel: viewModel)
    }
}
