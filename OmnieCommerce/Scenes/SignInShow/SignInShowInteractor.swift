//
//  SignInShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol SignInShowInteractorInput {
    func didUserSignIn(requestModel: SignInShowModels.User.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol SignInShowInteractorOutput {
    func presentSomething(responseModel: SignInShowModels.User.ResponseModel)
}

class SignInShowInteractor: SignInShowInteractorInput {
    // MARK: - Properties
    var presenter: SignInShowInteractorOutput!
    var worker: SignInShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func didUserSignIn(requestModel: SignInShowModels.User.RequestModel) {
        // NOTE: Create some Worker to do the work
        worker = SignInShowWorker()
        let result = worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let responseModel = SignInShowModels.User.ResponseModel(result: result)
        presenter.presentSomething(responseModel: responseModel)
    }
}
