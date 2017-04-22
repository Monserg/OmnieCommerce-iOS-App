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
    func organizationsDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationsShowModels.Organizations.ResponseModel)
    func servicesDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationsShowModels.Services.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol OrganizationsShowPresenterOutput: class {
    func organizationsDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Organizations.ViewModel)
    func servicesDidShowLoad(fromViewModel viewModel: OrganizationsShowModels.Services.ViewModel)
}

class OrganizationsShowPresenter: OrganizationsShowPresenterInput {
    // MARK: - Properties
    weak var viewController: OrganizationsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func organizationsDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationsShowModels.Organizations.ResponseModel) {
        guard responseModel.responseAPI?.body != nil else {
            let organizationsViewModel = OrganizationsShowModels.Organizations.ViewModel(status: (responseModel.responseAPI?.status)!)
            self.viewController.organizationsDidShowLoad(fromViewModel: organizationsViewModel)
            return
        }
        
        // Convert responseAPI body to Organization CoreData objects
        var counter: Int = 0
        
        for json in responseModel.responseAPI!.body as! [Any] {
            counter += 1
            let item = Organization.init(json: json as! [String: AnyObject])
            
            if let organization = item {
                organization.category = NSSet.init(object: responseModel.category)
                organization.catalog = keyOrganizations + responseModel.category.codeID
                organization.cellIdentifier = "OrganizationTableViewCell"
                organization.cellHeight = 96.0
                
                if let googlePlaceID = (json as! [String: AnyObject])["placeId"] as? String {
                    organization.googlePlaceDidLoad(positionID: googlePlaceID, completion: {
                        if (counter == (responseModel.responseAPI!.body as! [Any]).count) {
                            CoreDataManager.instance.didSaveContext()

                            let organizationsViewModel = OrganizationsShowModels.Organizations.ViewModel(status: (responseModel.responseAPI?.status)!)
                            self.viewController.organizationsDidShowLoad(fromViewModel: organizationsViewModel)
                        }
                    })
                }
            }
        }
    }

    func servicesDidPrepareToShowLoad(fromResponseModel responseModel: OrganizationsShowModels.Services.ResponseModel) {
        guard responseModel.responseAPI?.body != nil else {
            let servicesViewModel = OrganizationsShowModels.Services.ViewModel(services: nil, status: (responseModel.responseAPI?.status)!)
            self.viewController.servicesDidShowLoad(fromViewModel: servicesViewModel)
            return
        }
        
        // Convert Google Place ID to address strings
        responseModel.responseAPI!.itemsDidLoad(fromItemsArray: responseModel.responseAPI!.body as! [Any], withItem: Service.init(withCommonProfile: true), completion: { services in
            // Prepare to save Services in CoreData
            let _ = services.map { $0.category = responseModel.category }
            let entityServices = CoreDataManager.instance.entityDidLoad(byName: keyServices) as! Services
            let servicesData = NSKeyedArchiver.archivedData(withRootObject: services) as NSData?
            entityServices.list = servicesData!
            
            let servicesViewModel = OrganizationsShowModels.Services.ViewModel(services: services, status: (responseModel.responseAPI?.status)!)
            self.viewController.servicesDidShowLoad(fromViewModel: servicesViewModel)
        })
    }
}
