//
//  ServiceShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol ServiceShowInteractorInput {
    func serviceDidLoad(withRequestModel requestModel: ServiceShowModels.ServiceItem.RequestModel)
    func orderDidLoad(withRequestModel requestModel: ServiceShowModels.OrderItem.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol ServiceShowInteractorOutput {
    func serviceDidPrepareToShowLoad(fromResponseModel responseModel: ServiceShowModels.ServiceItem.ResponseModel)
    func orderDidPrepareToShowLoad(fromResponseModel responseModel: ServiceShowModels.OrderItem.ResponseModel)
}

class ServiceShowInteractor: ServiceShowInteractorInput {
    // MARK: - Properties
    var presenter: ServiceShowInteractorOutput!
    var worker: ServiceShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func serviceDidLoad(withRequestModel requestModel: ServiceShowModels.ServiceItem.RequestModel) {
        MSMRestApiManager.instance.userRequestDidRun(.userGetServiceByID(requestModel.parameters, false), withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let serviceResponseModel = ServiceShowModels.ServiceItem.ResponseModel(responseAPI: responseAPI, parameters: requestModel.parameters)
            self.presenter.serviceDidPrepareToShowLoad(fromResponseModel: serviceResponseModel)
        })
    }
    
    func orderDidLoad(withRequestModel requestModel: ServiceShowModels.OrderItem.RequestModel) {
        MSMRestApiManager.instance.userRequestDidRun(.userMakeNewOrder(requestModel.parameters, true), withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let orderResponseModel = ServiceShowModels.OrderItem.ResponseModel(responseAPI: responseAPI)
            self.presenter.orderDidPrepareToShowLoad(fromResponseModel: orderResponseModel)
        })
    }
}
