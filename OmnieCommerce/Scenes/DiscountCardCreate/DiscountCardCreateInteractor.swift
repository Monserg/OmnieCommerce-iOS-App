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
    func doSomething(requestModel: DiscountCardCreateModels.Something.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol DiscountCardCreateInteractorOutput {
    func presentSomething(responseModel: DiscountCardCreateModels.Something.ResponseModel)
}

class DiscountCardCreateInteractor: DiscountCardCreateInteractorInput {
    // MARK: - Properties
    var presenter: DiscountCardCreateInteractorOutput!
    var worker: DiscountCardCreateWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func doSomething(requestModel: DiscountCardCreateModels.Something.RequestModel) {
        // NOTE: Create some Worker to do the work
        worker = DiscountCardCreateWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let responseModel = DiscountCardCreateModels.Something.ResponseModel()
        presenter.presentSomething(responseModel: responseModel)
    }
}
