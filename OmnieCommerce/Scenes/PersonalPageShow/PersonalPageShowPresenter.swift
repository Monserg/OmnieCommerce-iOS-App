//
//  PersonalPageShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol PersonalPageShowPresenterInput {
    func userAppDataDidPrepareToShow(fromResponseModel responseModel: PersonalPageShowModels.UserApp.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol PersonalPageShowPresenterOutput: class {
    func userAppDataDidShow(fromViewModel viewModel: PersonalPageShowModels.UserApp.ViewModel)
}

class PersonalPageShowPresenter: PersonalPageShowPresenterInput {
    // MARK: - Properties
    weak var viewController: PersonalPageShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func userAppDataDidPrepareToShow(fromResponseModel responseModel: PersonalPageShowModels.UserApp.ResponseModel) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel   =   PersonalPageShowModels.UserApp.ViewModel(userApp: responseModel.userApp)
        viewController.userAppDataDidShow(fromViewModel: viewModel)
    }
}
