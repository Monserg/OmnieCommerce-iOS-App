//
//  TimeSheetViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class TimeSheetViewController: BaseViewController {
    // MARK: - Properties
    let cellHeightMin: CGFloat = 45.0
    let cellHeightMax: CGFloat = 104.0
    var timer = CustomTimer.init(withTimeInterval: 60)
    var timeSheetView: TimeSheetView?
    
    // Need to use after change date
    weak var timeSheet: TimeSheet!
    
    // DataSource of blocks ORDER & CLOSE
    var timeSheetItems = [TimeSheetItem]()

    // Array of block views
    var timeSheetViews = [TimeSheetView]()
    
    // Need for API after change date
    var serviceID: String!

    // Cell height
    var cellHeight: CGFloat = 64.0 {
        didSet {
            period.cellDivision = (timeSheet.minDuration) ? Float(cellHeight * CGFloat(timeSheet.orderDuration) / CGFloat(60.0)) : Float(cellHeight / CGFloat(60.0))
            period.cellHeight = Float(cellHeight)
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

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.layoutIfNeeded()
        
        currentTimeLine.draw(fromPoint: 60.0,
                                          withFinishOffset: 8.0, //(size.width > size.height) ? -8.0 : 16.0,
                                          andNewSize: CGSize.init(width: tableView.frame.width, height: 20.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup PinchGesture Recognizer
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlerPinchGesture(_:)))
        tableView.addGestureRecognizer(pinchGesture)
        
        // Setup LongPressGesture Recognizer
        let longPressedGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPressedGesture(_:)))
        longPressedGesture.minimumPressDuration = 1.5
        longPressedGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(longPressedGesture)
        
        // Setup TapGesture Recognizer
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlerTapGesture(_:)))
        tableView.addGestureRecognizer(tapGesture)
        
        // Setup Table view
        let tableViewManager = MSMTableViewControllerManager.init(withTableView: tableView,
                                                                  andSectionsCount: 1,
                                                                  andEmptyMessageText: "DropDownList")
        
        tableView.hasHeaders = false
        tableView.tableViewControllerManager = tableViewManager
        cellHeight = tableView.frame.height / 6.0
        
        // Create dataSource
        var dataSource = [TimeSheetCell]()
        
        for index in 0...23 {
            let start = "\(String(index).twoNumberFormat()):00"
            let end = (index == 23) ? "\(String(index).twoNumberFormat()):59" : "\(String(index + 1).twoNumberFormat()):00"
            
            dataSource.append(TimeSheetCell(start: start, end: end, cellIdentifier: "TimeSheetTableViewCell", cellHeight: cellHeight))
        }

        tableView.tableViewControllerManager!.dataSource = dataSource.sorted(by: { $0.start < $1.start })
        tableView.reloadData()
        
        // Handler select cell
        tableView.tableViewControllerManager!.handlerSelectRowCompletion = { item in }

        // Handler PullRefresh
        tableView.tableViewControllerManager!.handlerPullRefreshCompletion = { _ in }
        
        // Handler InfiniteScroll
        tableView.tableViewControllerManager.handlerInfiniteScrollCompletion = { _ in }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        timeLineViewDidLoad()
        timeSheetItemsDidUpload()
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
            currentTimeLine.frame = CGRect.init(origin: CGPoint.init(x: 60.0, y: 0.0), size: CGSize.init(width: tableView.frame.width - (60.0 + 8.0), height: 20.0))
            _ = Date().didShow(timeLineView: currentTimeLine, inTableView: tableView, withCellHeight: cellHeight)
            
            let topRowIndex = Calendar.current.dateComponents([.hour], from: Date()).hour! - 2
            
            if ((period.dateStart as Date).isActiveToday()) {
                self.tableView.scrollToRow(at: IndexPath.init(row: topRowIndex, section: 0), at: .top, animated: true)
            }
            
            // Setup Timer
            timer.start()
            currentTimeLine.isShow = true
            
            timer.handlerTimerActionCompletion = { counter in
                self.print(object: "timerLineView move to new position")
                
                if ((period.dateStart as Date).didShow(timeLineView: self.currentTimeLine, inTableView: self.tableView, withCellHeight: self.cellHeight)) {
                    self.currentTimeLine.didMoveToNewPosition(inTableView: self.tableView, withCellHeight: self.cellHeight, andAnimation: true)
                } else {
                    self.timer.stop()
                }
            }
        } else if !((period.dateStart as Date).isActiveToday()) {
            currentTimeLine.removeFromSuperview()
            currentTimeLine.isShow = false
            timer.stop()
        }
    }
    
    private func selectedDateDidUpload() {
        if (titleLabel != nil) {
            titleLabel.text = (period.dateStart as Date).convertToString(withStyle: .DayMonthYear)
        }
    }

    func timeSheetItemsDidUpload() {
        guard tableView != nil else {
            return
        }
        
        // Get data source
        if let items = timeSheet.timesheets, items.count > 0 {
            timeSheetItems = Array(items) as! [TimeSheetItem]
        }

        // Delete all old time sheet items
        for timeSheetView in timeSheetViews {
            timeSheetView.removeFromSuperview()
        }
        
        timeSheetViews.removeAll()
        
        // Show new time sheet items blocks
        for timeSheetItem in timeSheetItems {
            let timeStart = timeSheetItem.start.components(separatedBy: "T")
            let timeEnd = timeSheetItem.end.components(separatedBy: "T")
            let startHour = UInt(timeStart.last!.components(separatedBy: ":").first!)!
            let startMinute = UInt(timeStart.last!.components(separatedBy: ":").last!)!
            let endHour = UInt(timeEnd.last!.components(separatedBy: ":").first!)!
            let endMinute = UInt(timeEnd.last!.components(separatedBy: ":").last!)!
            
            let closeTimeSheetView = TimeSheetView.init(frame: CGRect.init(x: 80.0,
                                                                           y: CGFloat(CGFloat(startHour) + CGFloat(startMinute) * CGFloat(1.0)) * cellHeight - 0.5,
                                                                           width: tableView.frame.width - (80.0 + 8.0),
                                                                           height: CGFloat(endHour - startHour) * cellHeight + CGFloat(endMinute - startMinute) * CGFloat(1.0)))
            
            closeTimeSheetView.contentView.backgroundColor = UIColor.darkCyanAlpha70
            closeTimeSheetView.startTimeLabel.text = timeStart.last!
            closeTimeSheetView.finishTimeLabel.text = timeEnd.last!
            closeTimeSheetView.startTimeLabel.textColor = UIColor.white
            closeTimeSheetView.finishTimeLabel.textColor = UIColor.white
            closeTimeSheetView.separatorTimeLabel.textColor = UIColor.white
            closeTimeSheetView.isOrderOwn = false
            
            tableView.addSubview(closeTimeSheetView)
            timeSheetViews.append(closeTimeSheetView)
            
            tableView.reloadData()
            timeLineViewDidLoad()
        }
    }
    
    func timeSheetViewsDidRemove() {
        timeSheetView?.removeFromSuperview()
        timeSheetView = nil
        _ = timeSheetViews.map({ $0.removeFromSuperview() })
        timeSheetViews.removeAll()
    }
    
    
    // MARK: - Gestures
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)], \(sender.state)")
        
        if (sender.state == .began) {
            let touchPoint = sender.location(in: tableView)
            let orderDuration = (timeSheet.minDuration && timeSheet.orderDuration == 0) ? CGFloat(30.0) : CGFloat(timeSheet.orderDuration)
            let cellTouchPointIndex = tableView.indexPath(for: tableView.cellForRow(at: tableView.indexPathForRow(at: touchPoint)!)!)!.row
            let pointY: CGFloat =   (touchPoint.y < currentTimeLine.frame.minY &&
                                    (period.dateStart as Date).isActiveToday()) ?   currentTimeLine.frame.midY + CGFloat(period.cellDivision * 10.0) :
                                                                                    CGFloat(cellTouchPointIndex) * cellHeight
            
            if (timeSheetViews.filter({ $0.frame.contains(touchPoint) }).count > 0) {
                alertViewDidShow(withTitle: "Info", andMessage: "This time is busy.", completion: {})
            } else {
                // Create new Order TimeSheetView
                if (timeSheetView == nil) {
                    timeSheetView = TimeSheetView.init(frame: CGRect.init(x: 80.0,
                                                                          y: pointY,
                                                                          width: tableView.frame.width - (80.0 + 8.0),
                                                                          height: (timeSheet.minDuration) ? (CGFloat(period.cellDivision) * orderDuration) : CGFloat(period.cellDivision * 60.0)))
                    
                    timeSheetView!.convertToPeriod()
                    timeSheetView!.orderTimesDidUpload()
                    timeSheetView!.orderModeDidChange(to: .OrderResize)
                    timeSheetView!.isOrderOwn = true
                    
                    UIView.animate(withDuration: 0.7,
                                   delay: 0,
                                   options: .curveEaseIn,
                                   animations: {
                                        self.tableView.addSubview(self.timeSheetView!)
                    }, completion: { success in
                        self.handlerShowTimeSheetPickersCompletion!(true)
                    })
                } else {
                    // Move Order view to new position
                    let newPosition = CGPoint.init(x: timeSheetView!.frame.minX,
                                                   y: pointY)
                    
                    timeSheetView!.positionDidChange(to: newPosition)
                    timeSheetView!.convertToPeriod()
                    
                    if (touchPoint.y < currentTimeLine.frame.minY && (period.dateStart as Date).isActiveToday()) {
                        let topRowIndex = Calendar.current.dateComponents([.hour], from: Date()).hour! - 2
                        self.tableView.scrollToRow(at: IndexPath.init(row: topRowIndex, section: 0), at: .top, animated: true)
                    }
                }
                
//                // Handler show pickers view
//                self.handlerShowTimeSheetPickersCompletion!(false)
                
                // Handler begin resize mode
                self.timeSheetView!.handlerShowPickersViewCompletion = { _ in
                    self.handlerShowTimeSheetPickersCompletion!(true)
                }
                
                // Handler TimeSheetView move completion
                self.timeSheetView!.handlerTimeSheetViewChangeFrameCompletion = { _ in
                    self.handlerShowTimeSheetPickersCompletion!(false)
                }
            }
        }
    }
    
    func handlerPinchGesture(_ sender: UIPinchGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]. Sender state = \(sender.state)")

        handlerShowTimeSheetPickersCompletion!(false)

        if (sender.state == .changed) {
            if (cellHeightMin...cellHeightMax ~= cellHeight) {
                print(object: "\(sender.scale), \(cellHeight)")
                
                cellHeight *= sender.scale
                
                sender.scale = 1;
                
                tableView.reloadData()
            } else {
                if (cellHeight <= cellHeightMin) {
                    cellHeight = cellHeightMin
                } else if (cellHeight >= cellHeightMax) {
                    cellHeight = cellHeightMax
                }
            }
            
            currentTimeLine.didMoveToNewPosition(inTableView: tableView, withCellHeight: cellHeight, andAnimation: true)
        }
    }
    
    func handlerTapGesture(_ sender: UIGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        guard timeSheetView != nil else {
            return
        }
        
        if (timeSheetView!.gestureMode != .OrderPreview) {
            timeSheetView!.orderModeDidChange(to: .OrderMove)
            tableView.isScrollEnabled = true
            
            handlerShowTimeSheetPickersCompletion!(false)
            tableView.bringSubview(toFront: currentTimeLine)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        if !((period.dateStart as Date).isActiveToday()) {
            period.propertiesDidClear(withDate: false)
            timeSheetViewsDidRemove()
            period.dateStart = Calendar.current.date(byAdding: .day, value: -1, to: period.dateStart as Date)! as NSDate
            timer.stop()
            currentTimeLine.removeFromSuperview()
        }

        selectedDateDidUpload()
        tableView.isScrollEnabled = true

        handlerShowTimeSheetPickersCompletion!(false)
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        period.dateStart = Calendar.current.date(byAdding: .day, value: 1, to: period.dateStart as Date)! as NSDate
        period.propertiesDidClear(withDate: false)
        selectedDateDidUpload()
        timeSheetViewsDidRemove()
        tableView.isScrollEnabled = true
        
        handlerShowTimeSheetPickersCompletion!(false)
    }
}
