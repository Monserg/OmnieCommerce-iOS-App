//
//  ForgotPasswordShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol ForgotPasswordShowPresenterInput {
    func didPreparePassCode(fromResponseModel responseModel: ForgotPasswordShowModels.Code.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol ForgotPasswordShowPresenterOutput: class {
    func didPassCode(fromViewModel viewModel: ForgotPasswordShowModels.Code.ViewModel)
}

class ForgotPasswordShowPresenter: ForgotPasswordShowPresenterInput {
    // MARK: - Properties
    weak var viewController: ForgotPasswordShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func didPreparePassCode(fromResponseModel responseModel: ForgotPasswordShowModels.Code.ResponseModel) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = ForgotPasswordShowModels.Code.ViewModel(code: responseModel.code)
        viewController.didPassCode(fromViewModel: viewModel)
    }
}
