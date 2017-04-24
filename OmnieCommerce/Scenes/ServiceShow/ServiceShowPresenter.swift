//
//  ServiceShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 24.04.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol ServiceShowPresenterInput {
    func serviceDidPrepareToShowLoad(fromResponseModel responseModel: ServiceShowModels.ServiceItem.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol ServiceShowPresenterOutput: class {
    func serviceDidShowLoad(fromViewModel viewModel: ServiceShowModels.ServiceItem.ViewModel)
}

class ServiceShowPresenter: ServiceShowPresenterInput {
    // MARK: - Properties
    weak var viewController: ServiceShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func serviceDidPrepareToShowLoad(fromResponseModel responseModel: ServiceShowModels.ServiceItem.ResponseModel) {
        guard responseModel.responseAPI != nil else {
            let serviceViewModel = ServiceShowModels.ServiceItem.ViewModel(status: (responseModel.responseAPI?.status)!)
            viewController.serviceDidShowLoad(fromViewModel: serviceViewModel)
            
            return
        }
        
        // Convert responseAPI body to Service CoreData news objects
        let service = Service.init(json: responseModel.responseAPI?.body as! [String: AnyObject], andOrganization: nil)
        
        if let placeID = service!.placeID {
            service!.googlePlaceDidLoad(positionID: placeID, completion: { _ in
                CoreDataManager.instance.didSaveContext()
                
                let serviceViewModel = ServiceShowModels.ServiceItem.ViewModel(status: responseModel.responseAPI!.status)
                self.viewController.serviceDidShowLoad(fromViewModel: serviceViewModel)
            })
        }
    }
}
