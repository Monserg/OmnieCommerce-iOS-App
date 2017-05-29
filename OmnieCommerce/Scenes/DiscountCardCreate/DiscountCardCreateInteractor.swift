//
//  DiscountCardCreateInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol DiscountCardCreateInteractorInput {
    func discountCardDidCreate(withRequestModel requestModel: DiscountCardCreateModels.Create.RequestModel)
    func discountCardDidUpload(withRequestModel requestModel: DiscountCardCreateModels.Upload.RequestModel)
    func discountCardImageDidUpload(withRequestModel requestModel: DiscountCardCreateModels.Image.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol DiscountCardCreateInteractorOutput {
    func discountCardDidPrepareToShowCreate(fromResponseModel responseModel: DiscountCardCreateModels.Create.ResponseModel)
    func discountCardDidPrepareToShowUpload(fromResponseModel responseModel: DiscountCardCreateModels.Upload.ResponseModel)
    func discountCardImageDidPrepareToShowUpload(fromResponseModel responseModel: DiscountCardCreateModels.Image.ResponseModel)
}

class DiscountCardCreateInteractor: DiscountCardCreateInteractorInput {
    // MARK: - Properties
    var presenter: DiscountCardCreateInteractorOutput!
    var worker: DiscountCardCreateWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func discountCardDidCreate(withRequestModel requestModel: DiscountCardCreateModels.Create.RequestModel) {
        // NOTE: Pass the result to the Presenter
        MSMRestApiManager.instance.userRequestDidRun(.userCreateNewDiscountCard(requestModel.parameters, true), withHandlerResponseAPICompletion:  { responseAPI in
            let discountCardResponseModel = DiscountCardCreateModels.Create.ResponseModel(responseAPI: responseAPI)
            self.presenter.discountCardDidPrepareToShowCreate(fromResponseModel: discountCardResponseModel)
        })
    }
    
    func discountCardDidUpload(withRequestModel requestModel: DiscountCardCreateModels.Upload.RequestModel) {
        // NOTE: Pass the result to the Presenter
        MSMRestApiManager.instance.userRequestDidRun(.userEditDiscountCard(requestModel.parameters, true), withHandlerResponseAPICompletion:  { responseAPI in
            let discountCardResponseModel = DiscountCardCreateModels.Upload.ResponseModel(responseAPI: responseAPI, parameters: requestModel.parameters)
            self.presenter.discountCardDidPrepareToShowUpload(fromResponseModel: discountCardResponseModel)
        })
    }

    func discountCardImageDidUpload(withRequestModel requestModel: DiscountCardCreateModels.Image.RequestModel) {
        MSMRestApiManager.instance.userUploadImage(requestModel.image) { responseAPI in
            // Pass the result to the Presenter
            let imageUploadResponseModel = DiscountCardCreateModels.Image.ResponseModel(responseAPI: responseAPI)
            self.presenter.discountCardImageDidPrepareToShowUpload(fromResponseModel: imageUploadResponseModel)
        }
    }
}
