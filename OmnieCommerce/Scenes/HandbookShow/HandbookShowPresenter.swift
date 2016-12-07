//
//  HandbookShowPresenter.swift
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
protocol HandbookShowPresenterInput {
    func presentSomething(response: HandbookShow.Something.Response)
}

protocol HandbookShowPresenterOutput: class {
    func displaySomething(viewModel: HandbookShow.Something.ViewModel)
}

class HandbookShowPresenter: HandbookShowPresenterInput {
    // MARK: - Properties
    weak var output: HandbookShowPresenterOutput!
    
    
    // MARK: - Custom Functions. Presentation logic
    func presentSomething(response: HandbookShow.Something.Response) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = HandbookShow.Something.ViewModel()
        output.displaySomething(viewModel: viewModel)
    }
}
