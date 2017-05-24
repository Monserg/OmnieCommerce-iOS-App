//
//  DiscountCardShowInteractor.swift
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
protocol DiscountCardShowInteractorInput {
    func discountCardDidDelete(withRequestModel requestModel: DiscountCardShowModels.Item.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol DiscountCardShowInteractorOutput {
    func discountCardDidPrepareToShowDelete(fromResponseModel responseModel: DiscountCardShowModels.Item.ResponseModel)
}

class DiscountCardShowInteractor: DiscountCardShowInteractorInput {
    // MARK: - Properties
    var presenter: DiscountCardShowInteractorOutput!
    var worker: DiscountCardShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func discountCardDidDelete(withRequestModel requestModel: DiscountCardShowModels.Item.RequestModel) {
        // NOTE: Create some Worker to do the work
        worker = DiscountCardShowWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        MSMRestApiManager.instance.userRequestDidRun(.userDeleteDiscountCard(requestModel.parameters, false), withHandlerResponseAPICompletion:  { responseAPI in
            let discountCardResponseModel = DiscountCardShowModels.Item.ResponseModel(responseAPI: responseAPI)
            self.presenter.discountCardDidPrepareToShowDelete(fromResponseModel: discountCardResponseModel)
        })
    }
}
