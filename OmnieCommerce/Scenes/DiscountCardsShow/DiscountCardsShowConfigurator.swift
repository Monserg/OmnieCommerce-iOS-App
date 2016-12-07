//
//  DiscountCardsShowConfigurator.swift
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
extension DiscountCardsShowViewController: DiscountCardsShowPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension DiscountCardsShowInteractor: DiscountCardsShowViewControllerOutput {
}

extension DiscountCardsShowPresenter: DiscountCardsShowInteractorOutput {
}

class DiscountCardsShowConfigurator {
    // MARK: - Properties
    static let sharedInstance = DiscountCardsShowConfigurator()
    
    
    // MARK: - Class Initialization
    private init() {}
    

    // MARK: - Custom Functions
    func configure(viewController: DiscountCardsShowViewController) {
        let router = DiscountCardsShowRouter()
        router.viewController = viewController
        
        let presenter = DiscountCardsShowPresenter()
        presenter.output = viewController
        
        let interactor = DiscountCardsShowInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
