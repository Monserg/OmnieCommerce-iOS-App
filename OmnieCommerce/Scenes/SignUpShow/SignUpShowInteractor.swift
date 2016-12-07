//
//  SignUpShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol SignUpShowInteractorInput {
    func doSomething(request: SignUpShow.Something.Request)
}

protocol SignUpShowInteractorOutput {
    func presentSomething(response: SignUpShow.Something.Response)
}

class SignUpShowInteractor: SignUpShowInteractorInput {
    // MARK: - Properties
    var output: SignUpShowInteractorOutput!
    var worker: SignUpShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func doSomething(request: SignUpShow.Something.Request) {
        // NOTE: Create some Worker to do the work
        worker = SignUpShowWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let response = SignUpShow.Something.Response()
        output.presentSomething(response: response)
    }
}
