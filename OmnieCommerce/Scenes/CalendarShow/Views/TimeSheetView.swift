//
//  TimeSheetView.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetView: UIView {
    // MARK: - Properties
    var cell: TimeSheetTableViewCell?
    var startPosition = CGPoint.zero
    var originalHeight: CGFloat = 0
    var isResizeDown = true
    var orderMinDuration: CGFloat = 1.0
    var timesPeriod: TimesPeriod!

    var gestureMode = GestureMode.ScheduleMove {
        willSet {
            switch newValue {
            case .ScheduleMove:
                contentView.backgroundColor = UIColor.veryDarkCyan
                
            case .ScheduleResize:
                contentView.backgroundColor = UIColor.cyan
                
            default:
                break
            }
        }
    }
    
    var countServiceMinDown = 1 {
        willSet {
//            finishTimeLabel.text = String(orderStartTime + countServiceMinDown * Int(orderMinDuration)).twoNumberFormat()
        }
    }
    
    var countServiceMinUp = 1 {
        willSet {
//            startTimeLabel.text = String(orderStartTime - countServiceMinDown * Int(orderMinDuration)).twoNumberFormat()
        }
    }
    
    // Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var upDownButtonsCollection: [UIButton]!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    
    var handlerShowPickersViewCompletion: HandlerSendButtonCompletion?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Init from XIB
        UINib(nibName: String(describing: TimeSheetView.self), bundle: Bundle(for: TimeSheetView.self)).instantiate(withOwner: self, options: nil)
        view.frame = CGRect.init(origin: CGPoint.zero, size: frame.size)
        gestureMode = .ScheduleMove
        _ = upDownButtonsCollection.map{ $0.isHidden = true }
        originalHeight = frame.height
        addSubview(view)
        
        // Setup PanGesture Recognizer
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlerPanGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        addGestureRecognizer(panGesture)
        
        // Setup LongPressGesture Recognizer
        let longPressedGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPressedGesture(_:)))
        longPressedGesture.minimumPressDuration = 1.2
        addGestureRecognizer(longPressedGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Class Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        let tableView = superview as! UITableView
        tableView.isScrollEnabled = false
        
        let touch = touches.first!
        startPosition = touch.location(in: self)
        
        isResizeDown = (startPosition.y >= frame.height / 2) ? true : false
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        print(#function, #line)
    //
    //        // Change view height by gesture
    //        let touch = touches.first!
    //        let endPosition = touch.location(in: self)
    //        let difference = endPosition.y - startPosition.y
    //        let newFrame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: originalHeight + difference)
    //
    //        frame = newFrame
    //    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        let tableView = superview as! UITableView
        tableView.isScrollEnabled = true
    }
    
    func didChangeGestureMode(to mode: GestureMode) {
        gestureMode = mode
        _ = upDownButtonsCollection.map{ $0.isHidden = (mode == .ScheduleMove) ? true : false }
    }
    
    func didMove(to position: CGPoint) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
            self.frame = CGRect.init(origin: CGPoint.init(x: position.x, y: position.y), size: self.frame.size)
        }, completion: nil)
    }
    
    func setCurrentPeriod(_ period: TimesPeriod) {
        timesPeriod = period
        startTimeLabel.text = "\(String(period.hourStart).twoNumberFormat()):\(String(period.minuteStart).twoNumberFormat())"
        finishTimeLabel.text = "\(String(period.hourEnd).twoNumberFormat()):\(String(period.minuteEnd).twoNumberFormat())"
    }
    
    
    // MARK: - Actions
    func handlerPanGesture(_ sender: UIPanGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        switch gestureMode {
        case .ScheduleMove:
            let translate = sender.translation(in: self.superview!)
            sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translate.y)
            sender.setTranslation(CGPoint.zero, in: self.superview!)
            
            print(object: "sender.view!.frame")
            
        case .ScheduleResize:
            let translation = sender.translation(in: self.superview!)
            
            frame = (isResizeDown) ? CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.width, height: frame.height + translation.y)) : CGRect.init(origin: CGPoint.init(x: frame.origin.x, y: frame.origin.y + translation.y), size: CGSize.init(width: frame.width, height: frame.height - translation.y))
            
            for subview in (superview?.subviews)! as [UIView] {
                if ((subview.frame.contains(CGPoint.init(x: frame.minX, y: frame.maxY)) ||
                    subview.frame.contains(CGPoint.init(x: frame.minX, y: frame.minY))) && !subview.isUserInteractionEnabled) {
                    gestureMode = .TableGesture
                    _ = upDownButtonsCollection.map{ $0.isHidden = true}
                    
                    frame = (isResizeDown) ? CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.width, height: frame.height - 1.1)) : CGRect.init(origin: CGPoint.init(x: frame.minX, y: frame.minY - 1.1), size: frame.size)
                    sender.setTranslation(CGPoint.zero, in: self.superview!)
                    
                    if (isResizeDown) {
                        countServiceMinDown -= 1
                    } else {
                        countServiceMinUp += 1
                    }
                } else {
                    if (frame.height >= originalHeight) {
                        sender.setTranslation(CGPoint.zero, in: self.superview!)
                        
                        print(object: sender.view!.frame)
                    } else {
                        sender.setTranslation(CGPoint.init(x: 0, y: 1), in: self.superview!)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        if (gestureMode == .ScheduleMove) {
            didChangeGestureMode(to: .ScheduleResize)
            (superview as! UITableView).isScrollEnabled = false
            handlerShowPickersViewCompletion!()
        }
    }
}
