//
//  MessagesShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol MessagesShowPresenterInput {
    func messagesDidPrepareToShow(fromResponseModel responseModel: MessagesShowModels.Messages.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol MessagesShowPresenterOutput: class {
    func messagesDidShow(fromViewModel viewModel: MessagesShowModels.Messages.ViewModel)
}

class MessagesShowPresenter: MessagesShowPresenterInput {
    // MARK: - Properties
    weak var viewController: MessagesShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func messagesDidPrepareToShow(fromResponseModel responseModel: MessagesShowModels.Messages.ResponseModel) {
        let viewModel   =   MessagesShowModels.Messages.ViewModel(messages: responseModel.items)
        viewController.messagesDidShow(fromViewModel: viewModel)
    }
}
