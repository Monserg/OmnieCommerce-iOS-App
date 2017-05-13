//
//  NewsActionsShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 31.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol NewsActionsShowPresenterInput {
    func actionsDidPrepareToShowLoad(fromResponseModel responseModel: NewsActionsShowModels.Actions.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol NewsActionsShowPresenterOutput: class {
    func actionsDidShowLoad(fromViewModel viewModel: NewsActionsShowModels.Actions.ViewModel)
}

class NewsActionsShowPresenter: NewsActionsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: NewsActionsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func actionsDidPrepareToShowLoad(fromResponseModel responseModel: NewsActionsShowModels.Actions.ResponseModel) {
        guard responseModel.responseAPI != nil else {
            let actionsViewModel = NewsActionsShowModels.Actions.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.actionsDidShowLoad(fromViewModel: actionsViewModel)
            
            return
        }
        
        // Convert responseAPI body to NewsData action & Lists CoreData objects
        var items = [NewsData]()

        for json in responseModel.responseAPI!.body as! [Any] {
            let action = NewsData.init(json: json as! [String: AnyObject], isAction: true)
            items.append(action!)
        }

        CoreDataManager.instance.didSaveContext()

        let actionsViewModel = NewsActionsShowModels.Actions.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.actionsDidShowLoad(fromViewModel: actionsViewModel)
    }
}
