//
//  NewsShowConfigurator.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter
extension NewsShowViewController: NewsShowPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension NewsShowInteractor: NewsShowViewControllerOutput {
}

extension NewsShowPresenter: NewsShowInteractorOutput {
}

class NewsShowConfigurator {
    // MARK: - Properties
    static let sharedInstance = NewsShowConfigurator()
    
    
    // MARK: - Class Initialization
    private init() {}
    

    // MARK: - Custom Functions
    func configure(viewController: NewsShowViewController) {
        let router = NewsShowRouter()
        router.viewController = viewController
        
        let presenter = NewsShowPresenter()
        presenter.output = viewController
        
        let interactor = NewsShowInteractor()
        interactor.output = presenter
        
        viewController.output = interactor
        viewController.router = router
    }
}
