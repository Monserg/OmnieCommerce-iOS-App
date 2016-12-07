//
//  BusinessCardsShowConfigurator.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter
extension BusinessCardsShowViewController: BusinessCardsShowPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension BusinessCardsShowInteractor: BusinessCardsShowViewControllerOutput {
}

extension BusinessCardsShowPresenter: BusinessCardsShowInteractorOutput {
}

class BusinessCardsShowConfigurator {
    // MARK: - Properties
    static let sharedInstance = BusinessCardsShowConfigurator()
    
    
    // MARK: - Class Initialization
    private init() {}
    

    // MARK: - Custom Functions
    func configure(viewController: BusinessCardsShowViewController) {
        let router = BusinessCardsShowRouter()
        router.viewController = viewController
        
        let presenter = BusinessCardsShowPresenter()
        presenter.output = viewController
        
        let interactor = BusinessCardsShowInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
