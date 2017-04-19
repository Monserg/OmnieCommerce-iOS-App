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
        guard responseModel.responseAPI?.body != nil else {
            let actionsViewModel = NewsActionsShowModels.Actions.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.actionsDidShowLoad(fromViewModel: actionsViewModel)
            
            return
        }
        
        // Convert responseAPI body to NewsData CoreData action objects
        for json in responseModel.responseAPI!.body as! [Any] {
            let item = NewsData.init(json: json as! [String: AnyObject])
            
            if let action = item {
                action.isAction = true                
                CoreDataManager.instance.didSaveContext()
            }
        }
        
        let actionsViewModel = NewsActionsShowModels.Actions.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.actionsDidShowLoad(fromViewModel: actionsViewModel)

//        
//        
//        // Format the response from the Interactor and pass the result back to the View Controller
//        responseModel.responseAPI!.itemsDidLoad(fromItemsArray: responseModel.responseAPI!.body as! [Any], withItem: NewsData.init(), completion: { actions in
//            // Prepare to save NewsDataList in CoreData
//            let _ = actions.map { $0.isAction = true }
//            let entityActions = CoreDataManager.instance.entityDidLoad(byName: keyNewsActions) as! Actions
//            let actionsData = NSKeyedArchiver.archivedData(withRootObject: actions) as NSData?
//            entityActions.list = actionsData!
//            
//            let actionsViewModel = NewsActionsShowModels.Actions.ViewModel(actions: actions, status: (responseModel.responseAPI?.status)!)
//            self.viewController.actionsDidShowLoad(fromViewModel: actionsViewModel)
//        })
    }
}
