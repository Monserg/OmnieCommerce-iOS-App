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
    func codeDidLoad(fromRequestModel requestModel: ForgotPasswordShowModels.Code.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol ForgotPasswordShowInteractorOutput {
    func codeDidPrepareToShow(fromResponseModel responseModel: ForgotPasswordShowModels.Code.ResponseModel)
}

class ForgotPasswordShowInteractor: ForgotPasswordShowInteractorInput {
    // MARK: - Properties
    var presenter: ForgotPasswordShowInteractorOutput!
    var worker: ForgotPasswordShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func codeDidLoad(fromRequestModel requestModel: ForgotPasswordShowModels.Code.RequestModel) {
        MSMRestApiManager.instance.userForgotPassword(requestModel.data.email!, withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let responseModel = ForgotPasswordShowModels.Code.ResponseModel(code: (responseAPI != nil) ? responseAPI!.code : nil)
            self.presenter.codeDidPrepareToShow(fromResponseModel: responseModel)
        })
    }
}
