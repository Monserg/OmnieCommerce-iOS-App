//
//  TimeSheetViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

typealias TimePickerViewTimes = (isShow: Bool, isNewDate: Bool)

class TimeSheetViewController: BaseViewController {
    // MARK: - Properties
    let cellHeightMin: CGFloat = 52.0
    let cellHeightMax: CGFloat = 156.0
    var timer = CustomTimer.init(withTimeInterval: 60)
    var timeSheetView: TimeSheetView?
    
    // Work time without start & end CLOSE TimeSheetItems
    var startWorkHour: Int!
    var startWorkMinute: Int!
    var endWorkHour: Int!
    var endWorkMinute: Int!
    
    // Need to use after change date
    var timeSheet: TimeSheet!
    
    // DataSource of blocks ORDER & CLOSE
    var timeSheetItems = [TimeSheetItem]()

    // Array of block views
    var timeSheetViews = [TimeSheetView]()
    
    // Need for API after change date
    var serviceID: String!

    // Cell height
    var cellHeight: CGFloat = 64.0 {
        didSet {
            cellHeight = (cellHeight < cellHeightMin) ? cellHeightMin : (cellHeight > cellHeightMax) ? cellHeightMax : dataTableView.frame.height / 6.0
            period.cellHeight = Float(cellHeight)
            period.scale = (cellHeight == dataTableView.frame.height / 6) ? 1.0 : Float(oldValue / cellHeight)
        }
    }
    
    // Need to set iteration
    var serviceDuration: CGFloat = 1.0

    // Need to add to Order duration
    var additionalServicesDuration: CGFloat = 0.0

    var handlerShowTimeSheetPickersCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Outlets
    @IBOutlet weak var currentTimeLine: CurrentTimeLineView!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!

    @IBOutlet weak var dataTableView: MSMTableView! {
        didSet {
            dataTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            dataTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layoutIfNeeded()
        
        currentTimeLine.draw(fromPoint: 60.0,
                             withFinishOffset: 8.0,
                             andNewSize: CGSize.init(width: dataTableView.frame.width, height: 20.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TapGesture Recognizer
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlerTapGesture(_:)))
        dataTableView.addGestureRecognizer(tapGesture)
        
        // Setup PinchGesture Recognizer
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlerPinchGesture(_:)))
        dataTableView.addGestureRecognizer(pinchGesture)
        
        // Setup LongPressGesture Recognizer
        let longPressedGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPressedGesture(_:)))
        longPressedGesture.minimumPressDuration = 1.0
        longPressedGesture.cancelsTouchesInView = false
        dataTableView.addGestureRecognizer(longPressedGesture)
        
        // Setup Data Table view
        let dataTableViewManager = MSMTableViewControllerManager.init(withTableView: dataTableView,
                                                                      andSectionsCount: 1,
                                                                      andEmptyMessageText: "DropDownList")
        
        dataTableView.hasHeaders = false
        dataTableView.tableViewControllerManager = dataTableViewManager
        
        // Handler select cell
        dataTableView.tableViewControllerManager!.handlerSelectRowCompletion = { item in }

        // Handler PullRefresh
        dataTableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in }
        
        // Handler InfiniteScroll
        dataTableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in }
        
        timeSheetTableViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.timer.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    
    // MARK: - Custom Functions
    func timeLineViewDidLoad() {
        selectedDateDidUpload()

        // Start position
        if ((period.dateStart as Date).isActiveToday() && !currentTimeLine.isShow) {
            guard Int(period.workHourStart) <= Date().dateComponents().hour! else {
                return
            }

            currentTimeLine.frame = CGRect.init(origin: CGPoint.init(x: 60.0, y: 0.0), size: CGSize.init(width: dataTableView.frame.width - (60.0 + 8.0), height: 30.0))
            _ = Date().didShow(timeLineView: currentTimeLine, inTableView: dataTableView)
            
            let topRowIndex = Calendar.current.dateComponents([.hour], from: Date()).hour! - 2 - Int(period.workHourStart)
            
            if (topRowIndex < 0) {
                self.dataTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0),
                                               at: .top,
                                               animated: true)
            } else {
                self.dataTableView.scrollToRow(at: IndexPath.init(row: topRowIndex, section: 0),
                                               at: .top,
                                               animated: true)
            }
            
            // Setup Timer
            timer.start()
            currentTimeLine.isShow = true
            
            timer.handlerTimerActionCompletion = { counter in
                self.print(object: "timerLineView move to new position")
                
                if ((period.dateStart as Date).didShow(timeLineView: self.currentTimeLine, inTableView: self.dataTableView)) {
                    self.currentTimeLine.didMoveToNewPosition(inTableView: self.dataTableView, andAnimation: true)
                } else {
                    self.timer.stop()
                }
            }
        } else if !((period.dateStart as Date).isActiveToday()) {
            currentTimeLine.removeFromSuperview()
            currentTimeLine.isShow = false
            timer.stop()
            
            self.dataTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0),
                                           at: .top,
                                           animated: true)
        }
    }
    
    private func selectedDateDidUpload() {
        if (titleLabel != nil) {
            titleLabel.text = (period.dateStart as Date).convertToString(withStyle: .DayMonthYear)
        }
    }

    func timeSheetTableViewDidLoad() {
        guard dataTableView != nil else {
            return
        }

        startWorkHour = 0
        startWorkMinute = 0
        endWorkHour = 23
        endWorkMinute = 59
        
        cellHeight = dataTableView.frame.height / 6.0

        // Get TimeSheetItems
        if let items = timeSheet.timesheets, items.count > 0 {
            var timeSheetItemsList = Array(items) as! [TimeSheetItem]
            let timeSheetItemsListSorted = timeSheetItemsList.sorted(by: { ($0.startDate as Date) < ($1.startDate as Date) })
            timeSheetItemsList = timeSheetItemsListSorted
            
            // Delete first & last items
            if (timeSheetItemsListSorted.count == 1) {
                self.timeSheetItems = timeSheetItemsList
            }
            
            if (timeSheetItemsListSorted.count == 2) {
                startWorkHour = (timeSheetItemsListSorted.first!.endDate as Date).dateComponents().hour!
                startWorkMinute = (timeSheetItemsListSorted.first!.endDate as Date).dateComponents().minute!
                endWorkHour = (timeSheetItemsListSorted.last!.startDate as Date).dateComponents().hour!
                endWorkMinute = (timeSheetItemsListSorted.last!.startDate as Date).dateComponents().minute!
                
                // Delete start & end CLOSE TimeSheetItem
                timeSheetItemsList.removeAll()
                self.timeSheetItems = timeSheetItemsList
            }
            
            if (timeSheetItemsListSorted.count > 2) {
                var startTimeSheetItemDeleteIndex = 0
                var endTimeSheetItemDeleteIndex = 0

                // Find startWorkTime
                for (index, timeSheetItem) in timeSheetItemsListSorted.enumerated() {
                    let nextIndex = index + 1
                    
                    if (nextIndex < timeSheetItemsListSorted.count) {
                        let timeSheetItemForNextIndex = timeSheetItemsListSorted[nextIndex]
                        let minutesTimeSheetItemForIndex = (timeSheetItem.startDate as Date).dateComponents().hour! * 60 + (timeSheetItem.startDate as Date).dateComponents().minute!
                        let minutesTimeSheetItemForNextIndex = (timeSheetItemForNextIndex.startDate as Date).dateComponents().hour! * 60 + (timeSheetItemForNextIndex.startDate as Date).dateComponents().minute!
                        
                        if (minutesTimeSheetItemForNextIndex - minutesTimeSheetItemForIndex > 0) {
                            startWorkHour = (timeSheetItem.endDate as Date).dateComponents().hour!
                            startWorkMinute = (timeSheetItem.endDate as Date).dateComponents().minute!
                            startTimeSheetItemDeleteIndex = index
                        }
                    }
                }
                
                // Find endWorkTime
                for (index, timeSheetItem) in timeSheetItemsListSorted.reversed().enumerated() {
                    let previuosIndex = index - 1

                    if (previuosIndex >= 0) {
                        let timeSheetItemForPreviousIndex = timeSheetItemsListSorted[previuosIndex]
                        let minutesTimeSheetItemForIndex = (timeSheetItem.startDate as Date).dateComponents().hour! * 60 + (timeSheetItem.startDate as Date).dateComponents().minute!
                        let minutesTimeSheetItemForPreviousIndex = (timeSheetItemForPreviousIndex.startDate as Date).dateComponents().hour! * 60 + (timeSheetItemForPreviousIndex.startDate as Date).dateComponents().minute!

                        if (minutesTimeSheetItemForIndex - minutesTimeSheetItemForPreviousIndex > 0) {
                            endWorkHour = (timeSheetItem.startDate as Date).dateComponents().hour!
                            endWorkMinute = (timeSheetItem.startDate as Date).dateComponents().minute!
                            endTimeSheetItemDeleteIndex = index
                        }
                    }
                }
                
                // Delete start & end CLOSE TimeSheetItem
                timeSheetItemsList.remove(at: endTimeSheetItemDeleteIndex)
                timeSheetItemsList.remove(at: startTimeSheetItemDeleteIndex)
                
                self.timeSheetItems = timeSheetItemsList
            }
        }
        
        period.workHourStart = Int16(startWorkHour)
        period.workMinuteStart = Int16(startWorkMinute)
        period.workHourEnd = Int16(endWorkHour)
        period.workMinuteEnd = Int16(endWorkMinute)
        
        var dataSource = [TimeSheetCell]()
        
        for index in startWorkHour...endWorkHour {
            let start = "\(String(index).twoNumberFormat()):\(String(startWorkMinute).twoNumberFormat())"
            let end = (index == 23) ? "\(String(index).twoNumberFormat()):59" : "\(String(endWorkHour).twoNumberFormat()):\(String(endWorkMinute).twoNumberFormat())"
            
            // First cell apply start work minutes
//            if (index == 0 && startWorkMinute > 0) {
//                cellHeight = cellHeight / CGFloat(60 * startWorkMinute)
//            }
            
            // Last cell apply end work minutes
//            if (index == endWorkHour && endWorkMinute > 0) {
//                cellHeight = cellHeight / CGFloat(60 * endWorkMinute)
//            }
            
            dataSource.append(TimeSheetCell.init(start: start, end: end, height: cellHeight))
        }
        
        dataTableView.tableViewControllerManager!.dataSource = dataSource.sorted(by: { $0.start < $1.start })
        dataTableView.reloadData()
        timeSheetViewsDidUpload()
    }
    
    private func timeSheetViewsDidUpload() {
        guard dataTableView != nil else {
            return
        }
        
        // Delete all old time sheet items
        for timeSheetView in timeSheetViews {
            timeSheetView.removeFromSuperview()
        }
        
        timeSheetViews.removeAll()
        
        // Show new time sheet items blocks
        for timeSheetItem in timeSheetItems {
            let timeStart = timeSheetItem.startString.components(separatedBy: "T")
            let timeEnd = timeSheetItem.endString.components(separatedBy: "T")
            let startHour = UInt(timeStart.last!.components(separatedBy: ":").first!)!
            let startMinute = UInt(timeStart.last!.components(separatedBy: ":").last!)!
            let endHour = UInt(timeEnd.last!.components(separatedBy: ":").first!)!
            let endMinute = UInt(timeEnd.last!.components(separatedBy: ":").last!)!
            
            let closeTimeSheetView = TimeSheetView.init(frame: CGRect.init(x: 80.0,
                                                                           y: CGFloat(CGFloat(startHour) + CGFloat(startMinute) * CGFloat(1.0)) * cellHeight + 10.0,
                                                                           width: dataTableView.frame.width - (80.0 + 8.0),
                                                                           height: CGFloat(endHour - startHour) * cellHeight + CGFloat(endMinute - startMinute) * CGFloat(1.0)))
            
            closeTimeSheetView.contentView.backgroundColor = UIColor.darkCyanAlpha70
            closeTimeSheetView.startTimeLabel.text = timeStart.last!
            closeTimeSheetView.finishTimeLabel.text = timeEnd.last!
            closeTimeSheetView.startTimeLabel.textColor = UIColor.white
            closeTimeSheetView.finishTimeLabel.textColor = UIColor.white
            closeTimeSheetView.separatorTimeLabel.textColor = UIColor.white
            closeTimeSheetView.isOrderOwn = false
            
            dataTableView.addSubview(closeTimeSheetView)
            timeSheetViews.append(closeTimeSheetView)
            
            closeTimeSheetView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
            closeTimeSheetView.translatesAutoresizingMaskIntoConstraints = true
            closeTimeSheetView.leftAnchor.constraint(equalTo: dataTableView.leftAnchor, constant: 60.0).isActive = true
            closeTimeSheetView.rightAnchor.constraint(equalTo: dataTableView.rightAnchor, constant: 0.0).isActive = true
 
            dataTableView.reloadData()
        }

        timeLineViewDidLoad()
    }
    
    func timeSheetViewsDidRemove() {
        timeSheetView?.removeFromSuperview()
        timeSheetView = nil
        _ = timeSheetViews.map({ $0.removeFromSuperview() })
        timeSheetViews.removeAll()
    }
    
    func timeSheetViewPositionDidVerify(_ touchPoint: CGPoint) -> CGPoint? {
        let touchPointWithOffset = CGPoint.init(x: touchPoint.x, y: touchPoint.y + CGFloat(period.timeOffset))
        var cellTouchPointIndex = dataTableView.indexPath(for: dataTableView.cellForRow(at: dataTableView.indexPathForRow(at: touchPointWithOffset)!)!)!.row
        
        if ((cellTouchPointIndex + Int(period.workHourStart)) == Int(period.workHourEnd)) {
            cellTouchPointIndex -= 1

            // Verify current day & time: add 10 minutes for create new order
            if (touchPointWithOffset.y < currentTimeLine.frame.minY + 30 && (period.dateStart as Date).isActiveToday()) {
                return CGPoint.init(x: 80.0, y: currentTimeLine.frame.midY + (10.0 * cellHeight / 60.0))
            }
            
            // Verify TimeSheetView after end work time
            let touchRect = CGRect.init(origin: CGPoint.init(x: 80, y: CGFloat(cellTouchPointIndex) * cellHeight * CGFloat(period.scale) + CGFloat(period.timeOffset)),
                                        size: CGSize.init(width: 100.0, height: CGFloat(period.serviceDurationMinutes)))
            
            let afterWorkTimeRect = CGRect.init(origin: CGPoint.init(x: 0, y: CGFloat(cellTouchPointIndex) * cellHeight * CGFloat(period.scale) + CGFloat(period.timeOffset)),
                                                size: CGSize.init(width: dataTableView.frame.width, height: CGFloat(period.workMinuteEnd) * CGFloat(period.scale)))
            
            if (afterWorkTimeRect.contains(touchRect)) {
                return CGPoint.init(x: 80, y: CGFloat(cellTouchPointIndex) * cellHeight * CGFloat(period.scale) + CGFloat(period.timeOffset))
            } else {
                return nil
            }
        }
        
        // Verify TimeSheetView in CLOSE type
        if (timeSheetViews.filter({ $0.frame.contains(touchPoint) }).count > 0) {
            return nil
        }

        return CGPoint.init(x: 80, y: CGFloat(cellTouchPointIndex) * cellHeight + CGFloat(period.timeOffset))
    }
    

    // MARK: - Gestures
    func handlerTapGesture(_ sender: UIGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        guard timeSheetView != nil else {
            return
        }
        
        if (timeSheetView!.gestureMode != .OrderPreview) {
            timeSheetView!.gestureModeDidChange(to: .OrderMove)
            dataTableView.isScrollEnabled = true
            
            let timePickerViewTimes: TimePickerViewTimes = (isShow: false, isNewDate: false)
            handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
            
            dataTableView.bringSubview(toFront: currentTimeLine)
        }
    }
    
    func handlerPinchGesture(_ sender: UIPinchGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]. Sender state = \(sender.state)")
        
        switch sender.state {
        case .changed:
            print(object: "scale = \(sender.scale)")
            print(object: "\(sender.scale), \(cellHeight)")
            
            cellHeight *= sender.scale
            sender.scale = 1
            print(object: "scale = \(period.scale)")
            
            // Scale table view & cells
            let dataSource = dataTableView.tableViewControllerManager!.dataSource as! [TimeSheetCell]
            _ = dataSource.map({  $0.cellHeight = cellHeight })
            dataTableView.tableViewControllerManager!.dataSource = dataSource
            
            DispatchQueue.main.async(execute: {
                self.dataTableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            })
            
            DispatchQueue.main.async(execute: {
                self.timeSheetViewsDidUpload()
            })
            
//            if ((period.dateStart as Date).isActiveToday()) {
//                currentTimeLine.didMoveToNewPosition(inTableView: tableView, withCellHeight: cellHeight, andAnimation: true)
//            }
            
        case .ended:
            if ((period.dateStart as Date).isActiveToday()) {
                let topRowIndex = Calendar.current.dateComponents([.hour], from: Date()).hour! - 1
                self.dataTableView.scrollToRow(at: IndexPath.init(row: topRowIndex, section: 0), at: .top, animated: true)
                
                currentTimeLine.didMoveToNewPosition(inTableView: dataTableView, andAnimation: true)
            }
            
        default:
            break
        }
    }
    
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)], \(sender.state)")
        
        if (sender.state == .began) {
            let touchPoint = sender.location(in: dataTableView)
            
            // Verify new position
            let newPosition = timeSheetViewPositionDidVerify(touchPoint)
            
            guard newPosition != nil else {
                alertViewDidShow(withTitle: "Info", andMessage: "This time is busy.", completion: {})
                
                return
            }
            
            // Create UserTimeSheetView
            if (timeSheetView == nil) {
                let height = CGFloat(period.serviceDurationMinutes)
                
                timeSheetView = TimeSheetView.init(frame: CGRect.init(x: 80.0,y: newPosition!.y, width: dataTableView.frame.width - (80.0 + 8.0), height: height))
                
                UIView.animate(withDuration: 0.7,
                               delay: 0,
                               options: .curveEaseIn,
                               animations: {
                                self.dataTableView.addSubview(self.timeSheetView!)
                }, completion: { success in
                    self.timeSheetView!.gestureModeDidChange(to: .OrderResize)
                    self.timeSheetView!.isOrderOwn = true
                    
                    // Upload time
                    self.timeSheetView!.convertToPeriod()
                    self.timeSheetView!.selectedTimeDidUpload()

                    let timePickerViewTimes: TimePickerViewTimes = (isShow: true, isNewDate: false)
                    self.handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
                })
            }
                
                
            // Move UserTimeSheetView to new position
            else if (timeSheetView!.gestureMode != .OrderResize) {
                timeSheetView!.positionDidChange(to: newPosition!)

                // Upload time
                self.timeSheetView!.convertToPeriod()
                self.timeSheetView!.selectedTimeDidUpload()
            }

            // Handler begin resize mode completion
            self.timeSheetView!.handlerShowPickersViewCompletion = { _ in
                let timePickerViewTimes: TimePickerViewTimes = (isShow: true, isNewDate: false)
                self.handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
            }
            
            // Handler UserTimeSheetView frame position completion
            self.timeSheetView!.handlerTimeSheetViewChangePositionCompletion = { newPositionTranslationY in
                if let y = newPositionTranslationY as? CGFloat {
                    var newFramePosition: CGPoint!
                    
                    // Get UserYimeSheetView frame minY or maxY
                    newFramePosition = CGPoint.init(x: self.timeSheetView!.frame.minX, y: (y > 0) ? self.timeSheetView!.frame.maxY :
                                                                                                    self.timeSheetView!.frame.minY)

                    self.print(object: "newFramePosition = \(newFramePosition.y)")
                    
                    if (newFramePosition.y <= 9.9) {
                        newFramePosition = CGPoint.init(x: self.timeSheetView!.frame.minX, y: 10.0)
                        self.timeSheetView!.frame.origin = newFramePosition
                    } else if (newFramePosition.y >= self.dataTableView.frame.maxY + 0.1) {
                        newFramePosition = CGPoint.init(x: self.timeSheetView!.frame.minX, y: self.dataTableView.frame.maxY - self.timeSheetView!.frame.height)
                        self.timeSheetView!.frame.origin = newFramePosition
                    }

                    // Upload time
                    if (self.timeSheetViewPositionDidVerify(newFramePosition) != nil) {
                        self.timeSheetView!.convertToPeriod()
                        self.timeSheetView!.selectedTimeDidUpload()
                    }
                }
            }
            
            // Handler UserTimeSheetView frame resize completion
            self.timeSheetView!.handlerTimeSheetViewChangeFrameCompletion = { _ in
                let timePickerViewTimes: TimePickerViewTimes = (isShow: false, isNewDate: false)
                self.handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
            }
        }
    }


    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        var timePickerViewTimes: TimePickerViewTimes = (isShow: false, isNewDate: false)

        if !((period.dateStart as Date).isActiveToday()) {
            period.dateStart = Calendar.current.date(byAdding: .day, value: -1, to: period.dateStart as Date)! as NSDate
            timer.stop()
            currentTimeLine.removeFromSuperview()
            
            // New date
            timePickerViewTimes = (isShow: false, isNewDate: true)
        }

        period.propertiesDidClear(withDate: false)
        selectedDateDidUpload()
        timeSheetViewsDidRemove()
        dataTableView.isScrollEnabled = true

        handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        period.dateStart = Calendar.current.date(byAdding: .day, value: 1, to: period.dateStart as Date)! as NSDate
        
        period.propertiesDidClear(withDate: false)
        selectedDateDidUpload()
        timeSheetViewsDidRemove()
        dataTableView.isScrollEnabled = true
        
        let timePickerViewTimes: TimePickerViewTimes = (isShow: false, isNewDate: true)
        handlerShowTimeSheetPickersCompletion!(timePickerViewTimes)
    }
}
