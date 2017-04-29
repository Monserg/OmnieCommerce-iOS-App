//
//  RepetitionPasswordShowInteractor.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 08.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol RepetitionPasswordShowInteractorInput {
    func newPasswordDidChange(withRequestModel requestModel: RepetitionPasswordShowModels.Password.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol RepetitionPasswordShowInteractorOutput {
    func newPasswordDidPrepareToShowChange(fromResponseModel responseModel: RepetitionPasswordShowModels.Password.ResponseModel)
}

class RepetitionPasswordShowInteractor: RepetitionPasswordShowInteractorInput {
    // MARK: - Properties
    var presenter: RepetitionPasswordShowInteractorOutput!
    var worker: RepetitionPasswordShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func newPasswordDidChange(withRequestModel requestModel: RepetitionPasswordShowModels.Password.RequestModel) {
        let parameters = [ "email": requestModel.email, "password": requestModel.newPassword, "resetToken": requestModel.resetToken]
        MSMRestApiManager.instance.userRequestDidRun(.userChangePasswordFromLogin(parameters, true), withHandlerResponseAPICompletion: { responseAPI in
            let responseModel = RepetitionPasswordShowModels.Password.ResponseModel(response: responseAPI)
            self.presenter.newPasswordDidPrepareToShowChange(fromResponseModel: responseModel)
        })
    }
}
