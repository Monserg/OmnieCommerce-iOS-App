//
//  OnmieSoftShowInteractor.swift
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
protocol OnmieSoftShowInteractorInput {
    func doSomething(request: OnmieSoftShow.Something.Request)
}

protocol OnmieSoftShowInteractorOutput {
    func presentSomething(response: OnmieSoftShow.Something.Response)
}

class OnmieSoftShowInteractor: OnmieSoftShowInteractorInput {
    // MARK: - Properties
    var output: OnmieSoftShowInteractorOutput!
    var worker: OnmieSoftShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func doSomething(request: OnmieSoftShow.Something.Request) {
        // NOTE: Create some Worker to do the work
        worker = OnmieSoftShowWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let response = OnmieSoftShow.Something.Response()
        output.presentSomething(response: response)
    }
}
