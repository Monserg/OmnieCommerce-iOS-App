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
    var cellHeight: CGFloat = 64
    let cellHeightMin: CGFloat = 44
    let cellHeightMax: CGFloat = 104
    var gestureMode = GestureMode.TableGesture
    var timer = CustomTimer.init(withTimeInterval: 60)
    var currentScheduleView: TimeSheetView?
    var service: Service!
        var organization = Organization()
    var selectedDate = Date().addingTimeInterval(TimeInterval(0))
    var timesheet: TimeSheet!
    
    // Outlets
    @IBOutlet var currentTimeLine: TimePointer!

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
                                                                  andEmptyMessageText: "Schedule list is empty")
        
        tableView.tableViewControllerManager = tableViewManager
//        tableView.tableViewControllerManager!.dataSource = //Array(serviceProfile.prices!)
        tableView.tableFooterView!.isHidden = true
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupTableView(withSize: tableView.frame.size)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func setupTableView(withSize size: CGSize) {
        tableView.frame = CGRect.init(origin: tableView.frame.origin, size: size)
        cellHeight = tableView.frame.height / CGFloat(tableView.numberOfRows(inSection: 0))
        tableView.reloadData()
        
        setupTimePointer()
    }
    
    func setupTimePointer() {
        currentTimeLine.frame = CGRect.init(origin: CGPoint.init(x: 60, y: 0), size: CGSize.init(width: view.frame.width - (60 + 8), height: 15))
        _ = selectedDate.didShow(timePointer: currentTimeLine, forOrganization: organization, inTableView: tableView, withCellHeight: cellHeight)
        
        // Setup Timer
        timer.start()
        timer.handlerTimerActionCompletion = { counter in
            self.print(object: "timerPointer move to new position")
            
            if (self.selectedDate.didShow(timePointer: self.currentTimeLine, forOrganization: self.organization, inTableView: self.tableView, withCellHeight: self.cellHeight)) {
                self.currentTimeLine.didMoveToNewPosition(forOrganization: self.organization, inTableView: self.tableView, withCellHeight: self.cellHeight, andAnimation: true)
            } else {
                self.timer.stop()
            }
        }
    }
    
    
    // MARK: - Actions
    func handlerLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            print(object: "\(#file): \(#function) run in [line \(#line)]")
            
            let gestureLocation = sender.location(in: view)
            
            if let gestureIndexPath = tableView.indexPathForRow(at: gestureLocation) {
                // Change mode for currentScheduleView
                if let actionCell = tableView.cellForRow(at: gestureIndexPath) as? TimeSheetTableViewCell {
                    if (actionCell.isFree) {
                        if (currentScheduleView == nil) {
                            currentScheduleView = TimeSheetView.init(frame: CGRect.init(x: 85, y: actionCell.frame.minY + actionCell.dottedLineView.frame.maxY, width: actionCell.frame.width - (85 + 8), height: (actionCell.frame.height - 1) / service.durationMinRate))
                            currentScheduleView!.cell = actionCell
                            currentScheduleView!.setCurrentPeriod()
                            
                            let currentScheduleView2 = TimeSheetView.init(frame: CGRect.init(x: 85, y: actionCell.frame.minY + actionCell.dottedLineView.frame.maxY + 200, width: actionCell.frame.width - (85 + 8), height: (actionCell.frame.height - 1) / service.durationMinRate))
                            currentScheduleView2.cell = actionCell
                            currentScheduleView2.setCurrentPeriod()
                            
                            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                                self.tableView.addSubview(self.currentScheduleView!)
                                self.tableView.addSubview(currentScheduleView2)
                                currentScheduleView2.isUserInteractionEnabled = false
                            }, completion: nil)
                        } else {
                            let newPosition = CGPoint.init(x: (currentScheduleView?.frame.minX)!, y: actionCell.frame.minY + actionCell.dottedLineView.frame.maxY)
                            currentScheduleView?.didMove(to: newPosition)
                        }
                    } else {
                        self.alertViewDidShow(withTitle: "Error", andMessage: "This time is busy.", completion: {})
                    }
                }
            }
        }
    }
    
    func handlerPinchGesture(_ sender: UIPinchGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]. Sender state = \(sender.state)")

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
            
//            currentTimeLine.didMoveToNewPosition(forOrganization: organization, inTableView: tableView, withCellHeight: cellHeight, andAnimation: true)
        }
    }
    
    func handlerTapGesture(_ sender: UIGestureRecognizer) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        currentScheduleView?.didChangeGestureMode(to: .ScheduleMove)
        tableView.isScrollEnabled = true
    }
    
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
    }

    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentScheduleView?.draw(fromPoint: 85, withFinishOffset: 8, andNewSize: size)
        currentTimeLine.draw(fromPoint: 60, withFinishOffset: 8, andNewSize: size)
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

