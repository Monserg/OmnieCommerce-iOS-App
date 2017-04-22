//
//  OrganizationShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol OrganizationShowPresenterInput {
    func organizationDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationShowModels.OrganizationItem.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol OrganizationShowPresenterOutput: class {
    func organizationDidShowLoad(fromViewModel viewModel: OrganizationShowModels.OrganizationItem.ViewModel)
}

class OrganizationShowPresenter: OrganizationShowPresenterInput {
    // MARK: - Properties
    weak var viewController: OrganizationShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func organizationDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationShowModels.OrganizationItem.ResponseModel) {
        guard responseModel.responseAPI != nil else {
            let organizationViewModel = OrganizationShowModels.OrganizationItem.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.organizationDidShowLoad(fromViewModel: organizationViewModel)
            
            return
        }
        
        // Convert responseAPI body to Organization CoreData news objects
        let organization = Organization.init(json: responseModel.responseAPI?.body as! [String: AnyObject])
        
        if let placeID = organization!.placeID {
            organization!.googlePlaceDidLoad(positionID: placeID, completion: { _ in
                let organizationViewModel = OrganizationShowModels.OrganizationItem.ViewModel(status: responseModel.responseAPI!.status)
                self.viewController.organizationDidShowLoad(fromViewModel: organizationViewModel)
            })
        }
    }
}
