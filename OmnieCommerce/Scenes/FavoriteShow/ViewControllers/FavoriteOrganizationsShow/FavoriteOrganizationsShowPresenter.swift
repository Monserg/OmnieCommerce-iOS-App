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
        guard responseModel.responseAPI != nil else {
            let organizationsViewModel = FavoriteOrganizationsShowModels.Organizations.ViewModel(status: "RESPONSE_NIL")
            self.viewController.favoriteOrganizationsDidShowLoad(fromViewModel: organizationsViewModel)

            return
        }
        
        // Convert responseAPI body to Organization CoreData objects
        if let organizationsList = responseModel.responseAPI!.body as? [[String: AnyObject]], organizationsList.count > 0 {
            for jsonOrganization in organizationsList {
                if let organizationID = jsonOrganization["uuid"] as? String {
                    if let organization = CoreDataManager.instance.entityBy("Organization", andCodeID: organizationID) as? Organization {
                        organization.profileDidUpload(json: jsonOrganization, forList: keyFavoriteOrganizations)
                    }
                }
            }
        }
        
        CoreDataManager.instance.didSaveContext()
        
        let organizationsViewModel = FavoriteOrganizationsShowModels.Organizations.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.favoriteOrganizationsDidShowLoad(fromViewModel: organizationsViewModel)
    }
}
