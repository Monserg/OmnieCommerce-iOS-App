//
//  ForgotPasswordShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol ForgotPasswordShowInteractorInput {
    func didLoadCode(fromRequestModel requestModel: ForgotPasswordShowModels.Code.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol ForgotPasswordShowInteractorOutput {
    func didPreparePassCode(fromResponseModel responseModel: ForgotPasswordShowModels.Code.ResponseModel)
}

class ForgotPasswordShowInteractor: ForgotPasswordShowInteractorInput {
    // MARK: - Properties
    var presenter: ForgotPasswordShowInteractorOutput!
    var worker: ForgotPasswordShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func didLoadCode(fromRequestModel requestModel: ForgotPasswordShowModels.Code.RequestModel) {
        worker = ForgotPasswordShowWorker()
        let code = worker.didReceiveCode(withRequestModel: requestModel)
        
        let responseModel = ForgotPasswordShowModels.Code.ResponseModel(code: code)
        presenter.didPreparePassCode(fromResponseModel: responseModel)
    }
}
