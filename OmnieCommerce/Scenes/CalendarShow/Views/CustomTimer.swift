//
//  CustomTimer.swift
//  UITableViewCellPinchDemo
//
//  Created by msm72 on 14.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import Foundation

class CustomTimer {
    typealias HandlerTimerActionCompletion = (_ counter: Int) -> ()
    
    // MARK: - Properties
    var timer = Timer()
    var date = Date()
    var counter = 0
    var timeInterval: TimeInterval
    var handlerTimerActionCompletion: HandlerTimerActionCompletion?
    
    
    // MARK: - Class Initialization
    init(withTimeInterval timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    convenience init() {
        self.init(withTimeInterval: 0.0)
    }
    
    
    // MARK: - Class Functions
    func start() {
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(handlerAction), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
    }
    
    deinit {
        self.timer.invalidate()
    }
    
    
    // MARK: - Actions
    @objc func handlerAction() {
        counter += 1
        handlerTimerActionCompletion!(counter)
    }
}
