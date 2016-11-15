//
//  SettingsShowPresenter.swift
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
protocol SettingsShowPresenterInput {
    func presentSomething(response: SettingsShow.Something.Response)
}

protocol SettingsShowPresenterOutput: class {
    func displaySomething(viewModel: SettingsShow.Something.ViewModel)
}

class SettingsShowPresenter: SettingsShowPresenterInput {
    // MARK: - Properties
    weak var output: SettingsShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func presentSomething(response: SettingsShow.Something.Response) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = SettingsShow.Something.ViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
