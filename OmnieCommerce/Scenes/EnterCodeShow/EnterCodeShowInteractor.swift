//
//  EnterCodeShowInteractor.swift
//  OmnieCommerceAdmin
//
//  Created by msm72 on 07.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol EnterCodeShowInteractorInput {
    func codeDidLoad(withRequestModel requestModel: EnterCodeShowModels.Code.RequestModel)
    func enteredCodeDidCheck(withRequestModel requestModel: EnterCodeShowModels.EnterCode.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol EnterCodeShowInteractorOutput {
    func codeDidPrepareToShowLoad(fromResponseModel responseModel: EnterCodeShowModels.Code.ResponseModel)
    func enteredCodeDidPrepareToShowCheck(fromResponseModel responseModel: EnterCodeShowModels.EnterCode.ResponseModel)
}

class EnterCodeShowInteractor: EnterCodeShowInteractorInput {
    // MARK: - Properties
    var presenter: EnterCodeShowInteractorOutput!
    var worker: EnterCodeShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func codeDidLoad(withRequestModel requestModel: EnterCodeShowModels.Code.RequestModel) {
        MSMRestApiManager.instance.userForgotPassword(requestModel.email, withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let responseModel = EnterCodeShowModels.Code.ResponseModel(code: (responseAPI != nil) ? responseAPI!.code : nil)
            self.presenter.codeDidPrepareToShowLoad(fromResponseModel: responseModel)
        })
    }
    
    func enteredCodeDidCheck(withRequestModel requestModel: EnterCodeShowModels.EnterCode.RequestModel) {
        MSMRestApiManager.instance.userCheckEmail(requestModel.email, withCode: requestModel.code) { responseAPI in
            // Pass the result to the Presenter
            let responseModel = EnterCodeShowModels.EnterCode.ResponseModel(response: responseAPI)
            self.presenter.enteredCodeDidPrepareToShowCheck(fromResponseModel: responseModel)
        }
    }
}
