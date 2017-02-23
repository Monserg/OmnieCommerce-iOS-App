//
//  OrganizationsShowConfigurator.swift
//  OmnieCommerce
//
//  Created by msm72 on 23.02.17.
//  Copyright (c) 2017 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter
extension OrganizationsShowViewController: OrganizationsShowPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension OrganizationsShowInteractor: OrganizationsShowViewControllerOutput {
}

extension OrganizationsShowPresenter: OrganizationsShowInteractorOutput {
}

class OrganizationsShowConfigurator {
    // MARK: - Properties
    static let sharedInstance = OrganizationsShowConfigurator()
    
    
    // MARK: - Class initialization
    private init() {}
    

    // MARK: - Custom Functions
    func configure(viewController: OrganizationsShowViewController) {
        let router                  =   OrganizationsShowRouter()
        router.viewController       =   viewController
        
        let presenter               =   OrganizationsShowPresenter()
        presenter.viewController    =   viewController
        
        let interactor              =   OrganizationsShowInteractor()
        interactor.presenter        =   presenter
        
        viewController.interactor   =   interactor
        viewController.router       =   router
    }
}
