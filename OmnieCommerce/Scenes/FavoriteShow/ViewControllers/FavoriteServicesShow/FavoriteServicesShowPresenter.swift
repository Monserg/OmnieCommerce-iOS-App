//
//  FavoriteServicesShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 28.03.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol FavoriteServicesShowPresenterInput {
    func favoriteServicesDidPrepareToShowLoad(fromResponseModel responseModel: FavoriteServicesShowModels.Services.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol FavoriteServicesShowPresenterOutput: class {
    func favoriteServicesDidShowLoad(fromViewModel viewModel: FavoriteServicesShowModels.Services.ViewModel)
}

class FavoriteServicesShowPresenter: FavoriteServicesShowPresenterInput {
    // MARK: - Properties
    weak var viewController: FavoriteServicesShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func favoriteServicesDidPrepareToShowLoad(fromResponseModel responseModel: FavoriteServicesShowModels.Services.ResponseModel) {
        guard responseModel.responseAPI != nil else {
            let servicesViewModel = FavoriteServicesShowModels.Services.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.favoriteServicesDidShowLoad(fromViewModel: servicesViewModel)
            
            return
        }
        
        // Convert responseAPI body to Service CoreData objects
        if let servicesList = responseModel.responseAPI!.body as? [[String: AnyObject]], servicesList.count > 0 {
            for jsonService in servicesList {
                if let serviceID = jsonService["uuid"] as? String {
                    if let service = CoreDataManager.instance.entityBy("Service", andCodeID: serviceID) as? Service {
                        service.profileDidUpload(json: jsonService, forList: keyFavoriteServices)
                        service.cellHeight = 60.0
                        service.cellIdentifier = "FavoriteServiceTableViewCell"
                    }
                }
            }
        }
        
        CoreDataManager.instance.didSaveContext()

        let servicesViewModel = FavoriteServicesShowModels.Services.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.favoriteServicesDidShowLoad(fromViewModel: servicesViewModel)
    }
}
