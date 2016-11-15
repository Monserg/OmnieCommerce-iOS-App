//
//  BusinessCardsShowInteractor.swift
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
protocol BusinessCardsShowInteractorInput {
    func doSomething(request: BusinessCardsShow.Something.Request)
}

protocol BusinessCardsShowInteractorOutput {
    func presentSomething(response: BusinessCardsShow.Something.Response)
}

class BusinessCardsShowInteractor: BusinessCardsShowInteractorInput {
    // MARK: - Properties
    var output: BusinessCardsShowInteractorOutput!
    var worker: BusinessCardsShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func doSomething(request: BusinessCardsShow.Something.Request) {
        // NOTE: Create some Worker to do the work
        worker = BusinessCardsShowWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let response = BusinessCardsShow.Something.Response()
        output.presentSomething(response: response)
    }
}
