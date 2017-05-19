//
//  SettingsShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol SettingsShowInteractorInput {
    func appSettingsDidLoad(withRequestModel requestModel: SettingsShowModels.Items.RequestModel)
    func appSettingsDidUpload(withRequestModel requestModel: SettingsShowModels.Items.RequestModel)
}

protocol SettingsShowInteractorOutput {
    func appSettingsDidPrepareToShowLoad(fromResponseModel responseModel: SettingsShowModels.Items.ResponseModel)
    func appSettingsDidPrepareToShowUpload(fromResponseModel responseModel: SettingsShowModels.Items.ResponseModel)
}

class SettingsShowInteractor: SettingsShowInteractorInput {
    // MARK: - Properties
    var presenter: SettingsShowInteractorOutput!
    var worker: SettingsShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func appSettingsDidLoad(withRequestModel requestModel: SettingsShowModels.Items.RequestModel) {
        // API
        MSMRestApiManager.instance.userRequestDidRun(.userGetProfileSettings(nil, false), withHandlerResponseAPICompletion: { responseAPI in
            // NOTE: Pass the result to the Presenter
            let appSettingsResponseModel = SettingsShowModels.Items.ResponseModel(responseAPI: responseAPI)
            self.presenter.appSettingsDidPrepareToShowLoad(fromResponseModel: appSettingsResponseModel)
        })
    }
    
    func appSettingsDidUpload(withRequestModel requestModel: SettingsShowModels.Items.RequestModel) {
        // API
        MSMRestApiManager.instance.userRequestDidRun(.userUploadProfileSettings(requestModel.parameters!, true), withHandlerResponseAPICompletion: { responseAPI in
            // NOTE: Pass the result to the Presenter
            let appSettingsResponseModel = SettingsShowModels.Items.ResponseModel(responseAPI: responseAPI)
            self.presenter.appSettingsDidPrepareToShowUpload(fromResponseModel: appSettingsResponseModel)
        })
    }
}
