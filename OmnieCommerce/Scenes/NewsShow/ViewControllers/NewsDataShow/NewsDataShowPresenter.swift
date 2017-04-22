//
//  NewsDataShowPresenter.swift
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
protocol NewsDataShowPresenterInput {
    func newsDataDidPrepareToShowLoad(fromResponseModel responseModel: NewsDataShowModels.Data.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol NewsDataShowPresenterOutput: class {
    func newsDataDidShowLoad(fromViewModel viewModel: NewsDataShowModels.Data.ViewModel)
}

class NewsDataShowPresenter: NewsDataShowPresenterInput {
    // MARK: - Properties
    weak var viewController: NewsDataShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func newsDataDidPrepareToShowLoad(fromResponseModel responseModel: NewsDataShowModels.Data.ResponseModel) {
        guard responseModel.responseAPI?.body != nil else {
            let newsDataViewModel = NewsDataShowModels.Data.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.newsDataDidShowLoad(fromViewModel: newsDataViewModel)
            
            return
        }
        
        // Convert responseAPI body to NewsData CoreData news objects
        for json in responseModel.responseAPI!.body as! [Any] {
            let item = NewsData.init(json: json as! [String: AnyObject])
            
            if let newsData = item {
                newsData.isAction = false
                CoreDataManager.instance.didSaveContext()
            }
        }
        
        let newsDataViewModel = NewsDataShowModels.Data.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.newsDataDidShowLoad(fromViewModel: newsDataViewModel)
    }
}
