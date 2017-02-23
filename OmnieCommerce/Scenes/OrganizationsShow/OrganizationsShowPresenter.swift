//
//  OrganizationsShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol OrganizationsShowPresenterInput {
    func presentSomething(responseModel: OrganizationsShowModels.Something.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol OrganizationsShowPresenterOutput: class {
    func displaySomething(viewModel: OrganizationsShowModels.Something.ViewModel)
}

class OrganizationsShowPresenter: OrganizationsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: OrganizationsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func presentSomething(responseModel: OrganizationsShowModels.Something.ResponseModel) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = OrganizationsShowModels.Something.ViewModel()
        viewController.displaySomething(viewModel: viewModel)
    }
}
