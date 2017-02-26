//
//  OrganizationsShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol OrganizationsShowInteractorInput {
    func organizationsDidLoad(withRequestModel requestModel: OrganizationsShowModels.Organizations.RequestModel)
    func servicesDidLoad(withRequestModel requestModel: OrganizationsShowModels.DropDownList.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol OrganizationsShowInteractorOutput {
    func organizationsDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.Organizations.ResponseModel)
    func servicesDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.DropDownList.ResponseModel)
}

class OrganizationsShowInteractor: OrganizationsShowInteractorInput {
    // MARK: - Properties
    var presenter: OrganizationsShowInteractorOutput!
    var worker: OrganizationsShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func organizationsDidLoad(withRequestModel requestModel: OrganizationsShowModels.Organizations.RequestModel) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // NOTE: Create some Worker to do the work
        worker = OrganizationsShowWorker()
        worker.organizationsDidLoad()
        
        worker.handlerLocationCompletion = { organizations in
            // NOTE: Pass the result to the Presenter
            let responseModel = OrganizationsShowModels.Organizations.ResponseModel(result: organizations)
            self.presenter.organizationsDidPrepareToShow(fromResponseModel: responseModel)
        }
    }
    
    func servicesDidLoad(withRequestModel requestModel: OrganizationsShowModels.DropDownList.RequestModel) {
        worker          =   OrganizationsShowWorker()
        let services    =   worker.dropDownListDidLoad(withType: .Services)
        
        let servicesResponseModel = OrganizationsShowModels.DropDownList.ResponseModel(result: services)
        presenter.servicesDidPrepareToShow(fromResponseModel: servicesResponseModel)
    }

}
