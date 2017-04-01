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
        guard responseModel.responseAPI != nil else {
            let newsDataViewModel = NewsDataShowModels.Data.ViewModel(newsData: nil)
            viewController.newsDataDidShowLoad(fromViewModel: newsDataViewModel)
            
            return
        }
        
        // Format the response from the Interactor and pass the result back to the View Controller
        if ((responseModel.responseAPI!.body as! [Any]).count > 0) {
            responseModel.responseAPI!.itemsDidLoad(fromItemsArray: responseModel.responseAPI!.body as! [Any], withItem: NewsData.init(), completion: { newsData in
                // Prepare to save NewsDataList in CoreData
                let entityNews = CoreDataManager.instance.entityDidLoad(byName: keyNewsData) as! News
                let newsDataData = NSKeyedArchiver.archivedData(withRootObject: newsData) as NSData?
                entityNews.list = newsDataData!
                
                let newsDataViewModel = NewsDataShowModels.Data.ViewModel(newsData: newsData)
                self.viewController.newsDataDidShowLoad(fromViewModel: newsDataViewModel)
            })
        } else {
            let newsDataViewModel = NewsDataShowModels.Data.ViewModel(newsData: nil)
            viewController.newsDataDidShowLoad(fromViewModel: newsDataViewModel)
        }
    }
}
