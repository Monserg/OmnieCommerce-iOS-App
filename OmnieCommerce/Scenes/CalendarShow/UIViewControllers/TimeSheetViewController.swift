//
//  TimeSheetViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

enum GestureMode {
    case TableGesture
    case ScheduleMove
    case ScheduleResize
}

class TimeSheetViewController: BaseViewController {
    // MARK: - Properties
    let cellHeightMin: CGFloat = 45.0
    let cellHeightMax: CGFloat = 104.0
    var gestureMode = GestureMode.TableGesture
    var timer = CustomTimer.init(withTimeInterval: 60)
    var timeSheetView: TimeSheetView!
    
    // Need to use after change date
    weak var timeSheet: TimeSheet! {
        didSet {
            guard tableView != nil else {
                return
            }
            
            timeSheetItemsDidUpload()
        }
    }

    // DataSource of blocks ORDER & CLOSE
    var timeSheetItems = [TimeSheetItem]()

    // Array of block views
    var timeSheetViews = [TimeSheetView]()
    
    // Need for API after change date
    var serviceID: String!

    // Cell height
    var cellHeight: CGFloat = 64.0 {
        didSet {
            cellDivision = (timeSheet.minDuration) ?    CGFloat(cellHeight * CGFloat(timeSheet.orderDuration) / CGFloat(60.0)) :
                                                        CGFloat(cellHeight / CGFloat(60.0))
        }
    }

    // Need for allow duration
    var cellDivision: CGFloat = CGFloat(45.0 / 60.0)
    
    // Need to set iteration
    var serviceDuration: CGFloat = 1.0

    // Need to add to Order duration
    var additionalServicesDuration: CGFloat = 0.0

    var handlerShowTimeSheetPickersCompletion: HandlerPassDataCompletion?
    
    
    // MARK: - Outlets
    @IBOutlet weak var currentTimeLine: TimePointer!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!

    @IBOutlet weak var tableView: MSMTableView! {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    // MARK: - Class Functions
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
        
        timePointerDidLoad()
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
    func timePointerDidLoad() {
        selectedDateDidUpload()

        // Start position
        currentTimeLine.frame = CGRect.init(origin: CGPoint.init(x: 60.0, y: 0.0), size: CGSize.init(width: tableView.frame.width - (60.0 + 8.0), height: 15.0))
        
        _ = Date().didShow(timePointer: currentTimeLine, inTableView: tableView, withCellHeight: cellHeight)
        let topRowIndex = Calendar.current.dateComponents([.hour], from: Date()).hour! - 2
        tableView.scrollToRow(at: IndexPath.init(row: topRowIndex, section: 0), at: .top, animated: true)
        
        // Setup Timer
        timer.start()
        
        timer.handlerTimerActionCompletion = { counter in
            self.print(object: "timerPointer move to new position")
            
            if ((period.dateStart as Date).didShow(timePointer: self.currentTimeLine, inTableView: self.tableView, withCellHeight: self.cellHeight)) {
                self.currentTimeLine.didMoveToNewPosition(inTableView: self.tableView, withCellHeight: self.cellHeight, andAnimation: true)
            } else {
                self.timer.stop()
            }
        }
    }
    
    private func selectedDateDidUpload() {
        if (titleLabel != nil) {
            titleLabel.text = (period.dateStart as Date).convertToString(withStyle: .DayMonthYear)
        }
    }

    func timeSheetItemsDidUpload() {
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
            
            let timeSheetView = TimeSheetView.init(frame: CGRect.init(x: 80.0,
                                                                      y: CGFloat(CGFloat(startHour) + CGFloat(startMinute) * cellDivision) * cellHeight - 0.5,
                                                                      width: tableView.frame.width - (80.0 + 8.0),
                                                                      height: CGFloat((endHour * 60 + endMinute) - (startHour * 60 + startMinute)) * cellHeight * cellDivision))
            
            timeSheetView.contentView.backgroundColor = UIColor.darkCyanAlpha70
            timeSheetView.startTimeLabel.text = timeStart.last!
            timeSheetView.finishTimeLabel.text = timeEnd.last!
            timeSheetView.startTimeLabel.textColor = UIColor.white
            timeSheetView.finishTimeLabel.textColor = UIColor.white
            timeSheetView.separatorTimeLabel.textColor = UIColor.white
            timeSheetView.isOrderOwn = false
            
            tableView.addSubview(timeSheetView)
            timeSheetViews.append(timeSheetView)
            
            tableView.reloadData()
            timePointerDidLoad()
        }
    }
    
    
    // MARK: - Actions
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)], \(sender.state)")
        
        if (sender.state == .began) {
            let touchPoint = sender.location(in: tableView)
            
            if let pointIndexPath = tableView.indexPathForRow(at: touchPoint) {
                // Change mode for timeSheetView
                if let actionCell = tableView.cellForRow(at: pointIndexPath) as? TimeSheetTableViewCell {
//                    switch actionCell.type {
//                    case "FREE":
//                        if (timeSheetView == nil) {
//                            timeSheetView = TimeSheetView.init(frame: CGRect.init(x: 85,
//                                                                                  y: actionCell.frame.minY - 5,
//                                                                                  width: actionCell.frame.width - (85 + 8),
//                                                                                  height: (actionCell.frame.height + 10) / 1.0))
//                           
//                            timeSheetView!.cell = actionCell
//                            timeSheetView!.orderTimesDidUpload()
//                            
//                            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
//                                self.tableView.addSubview(self.timeSheetView!)
//                            }, completion: nil)
//                        } else {
//                            let newPosition = CGPoint.init(x: (timeSheetView?.frame.minX)!, y: actionCell.frame.minY + actionCell.currentTimeLineView.frame.maxY)
//                            timeSheetView?.didMove(to: newPosition)
//                        }
//                        
//                        // Handler show pickers view
//                        self.handlerShowTimeSheetPickersCompletion!(true)
//                        
//                        // Handler begin resize mode
//                        self.timeSheetView!.handlerShowPickersViewCompletion = { _ in
//                            self.handlerShowTimeSheetPickersCompletion!(true)
//                        }
//                        
//                    default:
//                        // CLOSE
//                        self.alertViewDidShow(withTitle: "Error", andMessage: "This time is busy.", completion: {})
//                    }
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
        
        if (gestureMode != .TableGesture) {
            timeSheetView?.didChangeGestureMode(to: .ScheduleMove)
            tableView.isScrollEnabled = true
            
            handlerShowTimeSheetPickersCompletion!(false)
            tableView.bringSubview(toFront: currentTimeLine)
        }
    }
    
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        let selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: period.dateStart as Date)!
        period.dateStart = (selectedDate.compare(Date()) == .orderedAscending) ? NSDate() : selectedDate as NSDate
        
        selectedDateDidUpload()
        handlerShowTimeSheetPickersCompletion!(false)
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        period.dateStart = Calendar.current.date(byAdding: .day, value: 1, to: period.dateStart as Date)! as NSDate
        selectedDateDidUpload()

        handlerShowTimeSheetPickersCompletion!(false)
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        timeSheetView?.draw(fromPoint: 85, withFinishOffset: 8, andNewSize: size)
        currentTimeLine.draw(fromPoint: 60, withFinishOffset: 8, andNewSize: size)
        handlerShowTimeSheetPickersCompletion!(false)
    }
}


// FIXME: - DELETE!!!
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return organization.workTimeDuration
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ScheduleTableViewCell
//        
//        // Setup cell
//        scheduleCell.setup(forRow: indexPath, withOrganization: organization, andService: service)
//        
//        return scheduleCell
//    }

