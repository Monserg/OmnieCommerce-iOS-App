//
//  FavoriteOrganizationsShowPresenter.swift
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
protocol FavoriteOrganizationsShowPresenterInput {
    func favoriteOrganizationsDidPrepareToShowLoad(fromResponseModel responseModel: FavoriteOrganizationsShowModels.Organizations.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol FavoriteOrganizationsShowPresenterOutput: class {
    func favoriteOrganizationsDidShowLoad(fromViewModel viewModel: FavoriteOrganizationsShowModels.Organizations.ViewModel)
}

class FavoriteOrganizationsShowPresenter: FavoriteOrganizationsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: FavoriteOrganizationsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func favoriteOrganizationsDidPrepareToShowLoad(fromResponseModel responseModel: FavoriteOrganizationsShowModels.Organizations.ResponseModel) {
        // Format the response from the Interactor and pass the result back to the View Controller
        if ((responseModel.response?.body as! [Any]).count > 0) {
            responseModel.response?.organizationsAddressDidLoad(responseModel.response?.body as! [Any], completion: { organizations in
                // Prepare to save Organizations in CoreData
//                let _ = organizations.map { $0.category = responseModel.category }
                let entityOrganizations = CoreDataManager.instance.entityDidLoad(byName: keyFavoriteOrganizations) as! Organizations
                let organizationsData = NSKeyedArchiver.archivedData(withRootObject: organizations) as NSData?
                entityOrganizations.list = organizationsData!
                
                let organizationsViewModel = FavoriteOrganizationsShowModels.Organizations.ViewModel(organizations: organizations)
                self.viewController.favoriteOrganizationsDidShowLoad(fromViewModel: organizationsViewModel)
            })
        } else {
            let organizationsViewModel = FavoriteOrganizationsShowModels.Organizations.ViewModel(organizations: nil)
            self.viewController.favoriteOrganizationsDidShowLoad(fromViewModel: organizationsViewModel)
        }
    }
}
