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
        guard responseModel.responseAPI?.body != nil else {
            let servicesViewModel = FavoriteServicesShowModels.Services.ViewModel(services: nil, status: (responseModel.responseAPI?.status)!)
            viewController.favoriteServicesDidShowLoad(fromViewModel: servicesViewModel)
            
            return
        }
        
        // Format the response from the Interactor and pass the result back to the View Controller
        responseModel.responseAPI!.itemsDidLoad(fromItemsArray: responseModel.responseAPI!.body as! [Any], withItem: Service.init(), completion: { favoriteServices in
            // Prepare to save Services in CoreData
            let _ = favoriteServices.map { $0.cellHeight = 60.0; $0.cellIdentifier = "FavoriteServiceTableViewCell" }
            let entityFavoriteServices = CoreDataManager.instance.entityDidLoad(byName: keyFavoriteServices) as! FavoriteServices
            let favoriteServicesData = NSKeyedArchiver.archivedData(withRootObject: favoriteServices) as NSData?
            entityFavoriteServices.list = favoriteServicesData!
            
            let servicesViewModel = FavoriteServicesShowModels.Services.ViewModel(services: favoriteServices, status: (responseModel.responseAPI?.status)!)
            self.viewController.favoriteServicesDidShowLoad(fromViewModel: servicesViewModel)
        })
    }
}
