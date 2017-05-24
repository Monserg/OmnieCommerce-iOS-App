//
//  DiscountCardCreatePresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol DiscountCardCreatePresenterInput {
    func discountCardDidPrepareToShowCreate(fromResponseModel responseModel: DiscountCardCreateModels.Item.ResponseModel)
    func discountCardImageDidPrepareToShowUpload(fromResponseModel responseModel: DiscountCardCreateModels.Image.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol DiscountCardCreatePresenterOutput: class {
    func discountCardDidShowCreate(fromViewModel viewModel: DiscountCardCreateModels.Item.ViewModel)
    func discountCardImageDidShowUpload(fromViewModel viewModel: DiscountCardCreateModels.Image.ViewModel)
}

class DiscountCardCreatePresenter: DiscountCardCreatePresenterInput {
    // MARK: - Properties
    weak var viewController: DiscountCardCreatePresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func discountCardDidPrepareToShowCreate(fromResponseModel responseModel: DiscountCardCreateModels.Item.ResponseModel) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let discountCardViewModel = DiscountCardCreateModels.Item.ViewModel(status: (responseModel.responseAPI?.status)!)
        viewController.discountCardDidShowCreate(fromViewModel: discountCardViewModel)
    }
    
    func discountCardImageDidPrepareToShowUpload(fromResponseModel responseModel: DiscountCardCreateModels.Image.ResponseModel) {
        let discountCardImageViewModel = DiscountCardCreateModels.Image.ViewModel(responseAPI: responseModel.responseAPI)
        viewController.discountCardImageDidShowUpload(fromViewModel: discountCardImageViewModel)
    }
}
