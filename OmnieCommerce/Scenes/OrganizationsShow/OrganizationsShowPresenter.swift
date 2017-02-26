//
//  OrganizationsShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol OrganizationsShowPresenterInput {
    func servicesDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.DropDownList.ResponseModel)
    func categoriesDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.DropDownList.ResponseModel)
    func organizationsDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.Organizations.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol OrganizationsShowPresenterOutput: class {
    func servicesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel)
    func categoriesDidShow(fromViewModel viewModel: OrganizationsShowModels.DropDownList.ViewModel)
    func organizationsDidShow(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel)
}

class OrganizationsShowPresenter: OrganizationsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: OrganizationsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func servicesDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.DropDownList.ResponseModel) {
        let servicesViewModel = OrganizationsShowModels.DropDownList.ViewModel(dropDownList: responseModel.result)
        viewController.servicesDidShow(fromViewModel: servicesViewModel)
    }
    
    func categoriesDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.DropDownList.ResponseModel) {
        let categoriesViewModel = OrganizationsShowModels.DropDownList.ViewModel(dropDownList: responseModel.result)
        viewController.categoriesDidShow(fromViewModel: categoriesViewModel)
    }

    func organizationsDidPrepareToShow(fromResponseModel responseModel: OrganizationsShowModels.Organizations.ResponseModel) {
        let viewModel = OrganizationsShowModels.Organizations.ViewModel(organizations: responseModel.result)
        viewController.organizationsDidShow(fromViewModel: viewModel)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
