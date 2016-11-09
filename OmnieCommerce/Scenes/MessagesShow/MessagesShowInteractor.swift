//
//  MessagesShowInteractor.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol MessagesShowInteractorInput {
    func doSomething(request: MessagesShow.Something.Request)
}

protocol MessagesShowInteractorOutput {
    func presentSomething(response: MessagesShow.Something.Response)
}

class MessagesShowInteractor: MessagesShowInteractorInput {
    // MARK: - Properties
    var output: MessagesShowInteractorOutput!
    var worker: MessagesShowWorker!
    
    
    // MARK: - Custom Functions. Business logic
    func doSomething(request: MessagesShow.Something.Request) {
        // NOTE: Create some Worker to do the work
        worker = MessagesShowWorker()
        worker.doSomeWork()
        
        // NOTE: Pass the result to the Presenter
        let response = MessagesShow.Something.Response()
        output.presentSomething(response: response)
    }
}
