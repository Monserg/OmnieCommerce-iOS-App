//
//  PersonalPageShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Interactor component VIP-cicle
protocol PersonalPageShowInteractorInput {
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel)
    func userAppDataDidUpdate(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel)
    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol PersonalPageShowInteractorOutput {
    func userAppDataDidPrepareToShowLoad(fromResponseModel responseModel: PersonalPageShowModels.Data.ResponseModel)
    func userAppDataDidPrepareToShowUpdate(fromResponseModel responseModel: PersonalPageShowModels.Data.ResponseModel)
    func userAppTemplatesDidPrepareToShowLoad(fromResponseModel responseModel: PersonalPageShowModels.Templates.ResponseModel)
}

class PersonalPageShowInteractor: PersonalPageShowInteractorInput {
    // MARK: - Properties
    var presenter: PersonalPageShowInteractorOutput!
    var worker: PersonalPageShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        MSMRestApiManager.instance.userGetProfileData { responseAPI in
            // Pass the result to the Presenter
            let loadResponseModel = PersonalPageShowModels.Data.ResponseModel(response: responseAPI)
            self.presenter.userAppDataDidPrepareToShowLoad(fromResponseModel: loadResponseModel)
        }
    }
    
    func userAppDataDidUpdate(withRequestModel requestModel: PersonalPageShowModels.Data.RequestModel) {
//        worker              =   PersonalPageShowWorker()
//        let userApp         =   worker.userAppDidUpdateOnServer(withParameters: requestModel.params)
//        
//        // NOTE: Pass the result to the Presenter
//        let responseModel   =   PersonalPageShowModels.UserApp.ResponseModel(userApp: userApp)
//        presenter.userAppDataDidPrepareToShow(fromResponseModel: responseModel)
    }
    
    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel) {
        worker = PersonalPageShowWorker()
        let items = worker.userAppTemplatesDidLoad(forUserApp: requestModel.userID)
        
        // Pass the result to the Presenter
        let responseModel = PersonalPageShowModels.Templates.ResponseModel(items: items)
        presenter.userAppTemplatesDidPrepareToShowLoad(fromResponseModel: responseModel)
    }
}
