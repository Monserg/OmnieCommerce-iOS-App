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
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel)
    func userAppDataDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadData.RequestModel)
    func userAppImageDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadImage.RequestModel)
    func userAppImageDidDelete(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel)
    func userAppPasswordDidChange(withRequestModel requestModel: PersonalPageShowModels.UploadData.RequestModel)
    func userAppEmailDidChange(withRequestModel requestModel: PersonalPageShowModels.ChangeEmail.RequestModel)
    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel)
}

// MARK: - Output protocols for Presenter component VIP-cicle
protocol PersonalPageShowInteractorOutput {
    func userAppDataDidPrepareToShowLoad(fromResponseModel responseModel: PersonalPageShowModels.LoadData.ResponseModel)
    func userAppDataDidPrepareToShowUpload(fromResponseModel responseModel: PersonalPageShowModels.UploadData.ResponseModel)
    func userAppImageDidPrepareToShowUpload(fromResponseModel responseModel: PersonalPageShowModels.UploadImage.ResponseModel)
    func userAppImageDidPrepareToShowDelete(fromResponseModel responseModel: PersonalPageShowModels.LoadData.ResponseModel)
    func userAppPasswordDidPrepareToShowChange(fromResponseModel responseModel: PersonalPageShowModels.UploadData.ResponseModel)
    func userAppEmailDidPrepareToShowChange(fromResponseModel responseModel: PersonalPageShowModels.ChangeEmail.ResponseModel)
    func userAppTemplatesDidPrepareToShowLoad(fromResponseModel responseModel: PersonalPageShowModels.Templates.ResponseModel)
}

class PersonalPageShowInteractor: PersonalPageShowInteractorInput {
    // MARK: - Properties
    var presenter: PersonalPageShowInteractorOutput!
    var worker: PersonalPageShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func userAppDataDidLoad(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel) {
        MSMRestApiManager.instance.userGetProfileData { responseAPI in
            // Pass the result to the Presenter
            let loadResponseModel = PersonalPageShowModels.LoadData.ResponseModel(responseAPI: responseAPI)
            self.presenter.userAppDataDidPrepareToShowLoad(fromResponseModel: loadResponseModel)
        }
    }
    
    func userAppDataDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadData.RequestModel) {
        let profileParameters = (requestModel.parameters as! [[String: Any]]).first!
        let passwordsParameters: [String: Any]? = ((requestModel.parameters as! [[String: Any]]).count > 1) ? (requestModel.parameters as! [[String: Any]]).last : nil
        
        MSMRestApiManager.instance.userUploadProfileData(profileParameters, withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let responseModel = PersonalPageShowModels.UploadData.ResponseModel(responseAPI: responseAPI, passwordsParams: passwordsParameters)
            self.presenter.userAppDataDidPrepareToShowUpload(fromResponseModel: responseModel)
        })
    }
    
    func userAppImageDidUpload(withRequestModel requestModel: PersonalPageShowModels.UploadImage.RequestModel) {
        MSMRestApiManager.instance.userUploadImage(requestModel.image) { responseAPI in
            // Pass the result to the Presenter
            let imageUploadResponseModel = PersonalPageShowModels.UploadImage.ResponseModel(responseAPI: responseAPI)
            self.presenter.userAppImageDidPrepareToShowUpload(fromResponseModel: imageUploadResponseModel)
        }
    }

    func userAppImageDidDelete(withRequestModel requestModel: PersonalPageShowModels.LoadData.RequestModel) {
        MSMRestApiManager.instance.userDeleteImage(withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let imageDeleteResponseModel = PersonalPageShowModels.LoadData.ResponseModel(responseAPI: responseAPI)
            self.presenter.userAppImageDidPrepareToShowDelete(fromResponseModel: imageDeleteResponseModel)
        })
    }
    
    func userAppPasswordDidChange(withRequestModel requestModel: PersonalPageShowModels.UploadData.RequestModel) {
        MSMRestApiManager.instance.userChangePasswordFromProfile(requestModel.parameters as! [String: Any], withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let passwordChangeResponseModel = PersonalPageShowModels.UploadData.ResponseModel(responseAPI: responseAPI, passwordsParams: nil)
            self.presenter.userAppPasswordDidPrepareToShowChange(fromResponseModel: passwordChangeResponseModel)
        })
    }

    func userAppEmailDidChange(withRequestModel requestModel: PersonalPageShowModels.ChangeEmail.RequestModel) {
        MSMRestApiManager.instance.userChangeEmail(requestModel.email, withHandlerResponseAPICompletion: { responseAPI in
            // Pass the result to the Presenter
            let emailChangeResponseModel = PersonalPageShowModels.ChangeEmail.ResponseModel(responseAPI: responseAPI)
            self.presenter.userAppEmailDidPrepareToShowChange(fromResponseModel: emailChangeResponseModel)
        })
    }

    func userAppTemplatesDidLoad(withRequestModel requestModel: PersonalPageShowModels.Templates.RequestModel) {
        worker = PersonalPageShowWorker()
        let items = worker.userAppTemplatesDidLoad(forUserApp: requestModel.userID)
        
        // Pass the result to the Presenter
        let responseModel = PersonalPageShowModels.Templates.ResponseModel(items: items)
        presenter.userAppTemplatesDidPrepareToShowLoad(fromResponseModel: responseModel)
    }
}
