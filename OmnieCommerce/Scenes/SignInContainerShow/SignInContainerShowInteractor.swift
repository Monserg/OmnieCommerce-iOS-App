//
//  SignInContainerShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol SignInContainerShowInteractorInput {
    func didUserSignIn(requestModel: SignInContainerShowModels.User.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol SignInContainerShowInteractorOutput {
    func presentSomething(responseModel: SignInContainerShowModels.User.ResponseModel)
}

class SignInContainerShowInteractor: SignInContainerShowInteractorInput {
    // MARK: - Properties
    var presenter: SignInContainerShowInteractorOutput!
    var worker: SignInContainerShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func didUserSignIn(requestModel: SignInContainerShowModels.User.RequestModel) {
        // NOTE: Create some Worker to do the work
        worker = SignInContainerShowWorker()
        let result = worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let responseModel = SignInContainerShowModels.User.ResponseModel(result: result)
        presenter.presentSomething(responseModel: responseModel)
    }
}
