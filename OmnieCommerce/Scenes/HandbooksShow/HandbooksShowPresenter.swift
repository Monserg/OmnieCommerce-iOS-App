//
//  HandbooksShowPresenter.swift
//  OmnieCommerce
//
//  Created by msm72 on 20.05.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input protocols for current Presenter component VIP-cicle
protocol HandbooksShowPresenterInput {
    func handbooksDidPrepareToShowLoad(fromResponseModel responseModel: HandbooksShowModels.Items.ResponseModel)
    func businessCardDidPrepareToShowCreateFromHandbook(fromResponseModel responseModel: HandbooksShowModels.BusinessCard.ResponseModel)
}

// MARK: - Output protocols for ViewController component VIP-cicle
protocol HandbooksShowPresenterOutput: class {
    func handbooksDidShowLoad(fromViewModel viewModel: HandbooksShowModels.Items.ViewModel)
    func businessCardDidShowCreateFromHandbook(fromViewModel viewModel: HandbooksShowModels.BusinessCard.ViewModel)
}

class HandbooksShowPresenter: HandbooksShowPresenterInput {
    // MARK: - Properties
    weak var viewController: HandbooksShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func handbooksDidPrepareToShowLoad(fromResponseModel responseModel: HandbooksShowModels.Items.ResponseModel) {
        guard responseModel.responseAPI != nil else {
            let handbooksViewModel = HandbooksShowModels.Items.ViewModel(status: "RESPONSE_NIL")
            self.viewController.handbooksDidShowLoad(fromViewModel: handbooksViewModel)
            
            return
        }
        
        // Convert responseAPI body to Handbook CoreData objects
        for jsonHandbook in responseModel.responseAPI!.body as! [[String: AnyObject]] {
            if let codeID = jsonHandbook["uuid"] as? String {
                if let handbook = CoreDataManager.instance.entityBy("Handbook", andCodeID: codeID) as? Handbook {
                    handbook.profileDidUpload(json: jsonHandbook, forList: keyHandbooks)
                }
            }
        }
        
        CoreDataManager.instance.didSaveContext()
        
        let handbooksViewModel = HandbooksShowModels.Items.ViewModel(status: (responseModel.responseAPI?.status)!)
        self.viewController.handbooksDidShowLoad(fromViewModel: handbooksViewModel)
    }
    
    func businessCardDidPrepareToShowCreateFromHandbook(fromResponseModel responseModel: HandbooksShowModels.BusinessCard.ResponseModel) {
        let businessCardViewModel = HandbooksShowModels.BusinessCard.ViewModel(status: (responseModel.responseAPI?.status)!)
        viewController.businessCardDidShowCreateFromHandbook(fromViewModel: businessCardViewModel)
    }
}
