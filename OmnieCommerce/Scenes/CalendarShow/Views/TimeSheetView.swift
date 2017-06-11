//
//  TimeSheetView.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

enum TimeSheetViewMode {
    case OrderPreview
    case OrderMove
    case OrderResize
}

class TimeSheetView: UIView {
    // MARK: - Properties
    var startPosition = CGPoint.zero
    var originalHeight: CGFloat = 0
    var isResizeDown = true
    var isOrderOwn = false

    var gestureMode = TimeSheetViewMode.OrderMove {
        willSet {
            switch newValue {
            case .OrderMove:
                contentView.backgroundColor = UIColor.veryLightGray
                
            case .OrderResize:
                contentView.backgroundColor = UIColor.init(hexString: "#a1e2e3", withAlpha: 1.0)
                
            default:
                break
            }
        }
    }
    
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var upDownButtonsCollection: [UIButton]!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var separatorTimeLabel: UILabel!
    
    var handlerShowPickersViewCompletion: HandlerSendButtonCompletion?
    var handlerTimeSheetViewChangeFrameCompletion: HandlerSendButtonCompletion?
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Init from XIB
        UINib(nibName: String(describing: TimeSheetView.self), bundle: Bundle(for: TimeSheetView.self)).instantiate(withOwner: self, options: nil)
        view.frame = CGRect.init(origin: CGPoint.zero, size: frame.size)
        gestureMode = .OrderMove
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
    
    
    // MARK: - Custom Functions
    func orderModeDidChange(to mode: TimeSheetViewMode) {
        gestureMode = mode
        _ = upDownButtonsCollection.map{ $0.isHidden = (mode == .OrderMove) ? true : false }
    }
    
    func positionDidChange(to position: CGPoint) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        // Change position after long press
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
            self.frame = CGRect.init(origin: CGPoint.init(x: position.x, y: position.y), size: self.frame.size)
            self.didVerifyPositionBeforeMove()
            self.convertToPeriod()
            self.orderTimesDidUpload()
        }, completion: nil)
    }
    
    private func didVerifyPositionBeforeMove() {
        // Verify 0 hour
        if (self.frame.minY <= 0.0) {
            self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX, y: 0.0),
                                     size: self.frame.size)
        }
        
        // Verify current time
        for subview in (superview?.subviews)! as [UIView] {
            // Verify TimePointer time
            if (subview is TimePointer && (period.dateStart as Date).isActiveToday()) {
                if (self.frame.minY <= subview.frame.midY) {
                    self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX, y: subview.frame.midY),
                                             size: self.frame.size)
                }
            }
            
            // Verify free time
            if ((subview is TimeSheetView) && !(subview as! TimeSheetView).isOrderOwn) {
                if (self.frame.intersects(subview.frame))  {
                    // Move up
                    if (subview.frame.midY < self.frame.midY) {
                        self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX,
                                                                      y: subview.frame.maxY),
                                                 size: self.frame.size)
                    } else {
                        self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.minX,
                                                                      y: subview.frame.minY - self.frame.height),
                                                 size: self.frame.size)
                    }
                }
            }
        }
        
        self.convertToPeriod()
        handlerTimeSheetViewChangeFrameCompletion!()
    }
    
    func frameDidChangeFromPeriod() {
        UIView.animate(withDuration: 0.7, animations: {
            self.frame = CGRect.init(x: self.frame.minX,
                                     y: CGFloat(Float(period.hourStart) * period.cellHeight) + CGFloat(period.minuteStart),
                                     width: self.frame.width,
                                     height: CGFloat(Float(period.hourEnd - period.hourStart) * period.cellHeight) + CGFloat(period.minuteEnd - period.minuteStart))
        })
        
        orderTimesDidUpload()
    }
    
    func orderTimesDidUpload() {
        startTimeLabel.text = "\(String(period.hourStart).twoNumberFormat()):\(String(period.minuteStart).twoNumberFormat())"
        finishTimeLabel.text = "\(String(period.hourEnd).twoNumberFormat()):\(String(period.minuteEnd).twoNumberFormat())"
    }
    
    
    // MARK: - Actions
    func handlerPanGesture(_ sender: UIPanGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        if (isOrderOwn) {
            switch gestureMode {
            case .OrderMove:
                let translate = sender.translation(in: self.superview!)
                sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translate.y)
                sender.setTranslation(CGPoint.zero, in: self.superview!)
                
                didVerifyPositionBeforeMove()
                
            case .OrderResize:
                let translation = sender.translation(in: self.superview!)
                isResizeDown = (startPosition.y >= frame.height / 2) ? true : false
                
                frame = (isResizeDown) ?    CGRect.init(origin: frame.origin,
                                                        size: CGSize.init(width: frame.width, height: frame.height + translation.y)) :
                                            CGRect.init(origin: CGPoint.init(x: frame.origin.x, y: frame.origin.y + translation.y),
                                                        size: CGSize.init(width: frame.width, height: frame.height - translation.y))
                
                // Verify 0 hour
                if (sender.view!.frame.minY <= 0.0) {
                    sender.view!.frame = CGRect.init(origin: CGPoint.init(x: sender.view!.frame.minX, y: 0.0),
                                                     size: sender.view!.frame.size)
                }

                // Verify current time
                for subview in (superview?.subviews)! as [UIView] {
                    // Verify TimePointer time
                    if (subview is TimePointer && (period.dateStart as Date).isActiveToday()) {
                        if (sender.view!.frame.minY <= subview.frame.midY) {
                            sender.view!.frame = CGRect.init(origin: CGPoint.init(x: sender.view!.frame.minX, y: subview.frame.midY),
                                                             size: sender.view!.frame.size)
                        }
                    }
                    
                    // Verify free time
                    if ((subview.frame.contains(CGPoint.init(x: frame.minX, y: frame.maxY)) ||
                        subview.frame.contains(CGPoint.init(x: frame.minX, y: frame.minY))) && !subview.isUserInteractionEnabled) {
                        gestureMode = .OrderPreview
                        _ = upDownButtonsCollection.map{ $0.isHidden = true}
                        
                        frame = (isResizeDown) ? CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.width, height: frame.height - 1.1)) : CGRect.init(origin: CGPoint.init(x: frame.minX, y: frame.minY - 1.1), size: frame.size)
                        sender.setTranslation(CGPoint.zero, in: self.superview!)
                        
                        //                    if (isResizeDown) {
                        //                        countServiceMinDown -= 1
                        //                    } else {
                        //                        countServiceMinUp += 1
                        //                    }
                    } else {
                        if (frame.height >= originalHeight) {
                            sender.setTranslation(CGPoint.zero, in: self.superview!)
                            
                            print(object: sender.view!.frame)
                        } else {
                            sender.setTranslation(CGPoint.init(x: 0, y: 1), in: self.superview!)
                        }
                    }
                }
                
                sender.view!.convertToPeriod()

            default:
                break
            }
            
            orderTimesDidUpload()
            
            // Inform TimeSheetShowVC about change position
            handlerTimeSheetViewChangeFrameCompletion!()
        }
    }
    
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        if (gestureMode == .OrderMove && isOrderOwn) {
            orderModeDidChange(to: .OrderResize)
            (superview as! UITableView).isScrollEnabled = false
            (superview as! UITableView).bringSubview(toFront: self)
            
            handlerShowPickersViewCompletion!()
        }
    }
}
