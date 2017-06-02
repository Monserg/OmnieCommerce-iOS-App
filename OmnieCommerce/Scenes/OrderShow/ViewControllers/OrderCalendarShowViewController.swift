//
//  OrderCalendarShowViewController.swift
//  OmnieCommerce
//
//  https://patchthecode.github.io/RangeSelection/
// 
//
//  Created by msm72 on 15.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import JTAppleCalendar


class OrderCalendarShowViewController: BaseViewController {
    // MARK: - Properties
    let firstDayOfWeek: DaysOfWeek = .monday
    var ordersDatesPeriod: DatesPeriod!
    var calculatedDate = Date().globalTime()
    var firstDate: Date?
    
    var handlerSelectDatesPeriodCompletion: HandlerPassDataCompletion?

    // Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet var weekdayLabelsCollection: [UbuntuLightDarkCyanLabel]!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollViewBase = scrollView
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Continuous range selection
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        calendarView.allowsMultipleSelection = true
        calendarView.rangeSelectionWillBeUsed = true

        // Delegates
        calendarView.dataSource = self
        calendarView.delegate = self

        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        haveMenuItem = false
        
        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            self.navigationController?.popViewController(animated: true)
        }

        // Register DayCellView from XIB
        calendarView.registerCellViewXib(file: "CalendarDayCellView")
        
        // Setup cells insets
        calendarView.cellInset = CGPoint(x: 10, y: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setupCalendarView()
        
        // Add Calendar scrolling
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.scrollToDate(Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Custom Functions
    func setupCalendarView() {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        // Set weekday symbols
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        var weekdaySymbols = Array<String>()
        var count: Int = 0

        // Show Orders dates
        if (ordersDatesPeriod.0 == ordersDatesPeriod.1) {
            calendarView.selectDates([ordersDatesPeriod.0], triggerSelectionDelegate: false)
        } else {
            // TODO: -ADD PERIOD DATES
        }
        
                
        for (index, weekdaySymbol) in dateFormatter.shortStandaloneWeekdaySymbols.enumerated() {
            if (index < firstDayOfWeek.rawValue - 1) {
                weekdaySymbols.append(weekdaySymbol)
            } else {
                weekdaySymbols.insert(weekdaySymbol, at: count)
                count += 1
            }
        }
        
        _ = weekdayLabelsCollection.map ({
            $0.text = (weekdaySymbols[weekdayLabelsCollection.index(of: $0)!])
            
            // FIXME: - Add support first symbol upperCase
            $0.attributedText = NSAttributedString(string: $0.text!.uppercaseFirst, attributes: UIFont.ubuntuLightDarkCyan16)
        })
    }
    
    func setupTitleLabel(withDate date: Date) {
        titleLabel.text = date.convertToString(withStyle: .MonthYear)
    }
    
    
    
    
    func handleSelection(cell: JTAppleDayCellView?, cellState: CellState) {
        let dayCustomCell = cell as! CalendarDayCellView
        
        switch cellState.selectedPosition() {
        case .full:
            print(object: cellState.selectedPosition())

        case .left:
            print(object: cellState.selectedPosition())

        case .right:
            print(object: cellState.selectedPosition())

        case .middle:
            print(object: cellState.selectedPosition())

//        myCustomCell.selectedView.isHidden = false
//            myCustomCell.selectedView.backgroundColor = UIColor.init(hexString: "#24323f")!
            // Or you can put what ever you like for your rounded corners, and your stand-alone selected cell
            
        default:
            print(object: cellState.selectedPosition())
//            myCustomCell.selectedView.isHidden = true
//            myCustomCell.selectedView.backgroundColor = nil // Have no selection when a cell is not selected
        }
        
        dayCustomCell.setSelection(forState: cellState)
    }
    
    
    
    
    
    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                self.calculatedDate = self.calculatedDate.previousMonth()
                self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
            }
        }
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                self.calculatedDate = self.calculatedDate.nextMonth()
                self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
            }
        }
    }
    
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        var rangeSelectedDates: [Date] = []
        let point = gesture.location(in: gesture.view!)
        
//        rangeSelectedDates = calendarView.selectedDates
        
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            
            if !rangeSelectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
                ordersDatesPeriod = (dateStart: calendarView.selectedDates.first!, dateEnd: calendarView.selectedDates.last!)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let followingDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
    
    @IBAction func handlerSelectPeriodButtonTap(_ sender: BorderVeryLightOrangeButton) {
        ordersDatesPeriod = (dateStart: calendarView.selectedDates.first!, dateEnd: calendarView.selectedDates.last!)
        handlerSelectDatesPeriodCompletion!(ordersDatesPeriod)
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - JTAppleCalendarViewDataSource
extension OrderCalendarShowViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        let startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date(), wrappingComponents: false)!
        let endDate = Calendar.current.date(byAdding: .month, value: 12, to: Date(), wrappingComponents: false)!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: firstDayOfWeek)
        
        return parameters
    }
}


// MARK: - JTAppleCalendarViewDelegate
extension OrderCalendarShowViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        if firstDate != nil {
            calendarView.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        } else {
            firstDate = date
        }
        
//        handleSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCustomCell = cell as! CalendarDayCellView

        // Setup Day
        dayCustomCell.setupBeforeDisplay(forDate: date, withState: cellState)
        handleSelection(cell: cell, cellState: cellState)
    }
    
    
    /*
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCustomCell = cell as! CalendarDayCellView
        
        // Setup Day
        dayCustomCell.setupBeforeDisplay(forDate: date, withState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let dayCustomCell = cell as? CalendarDayCellView
        
        guard dayCustomCell != nil else {
            return
        }
        
        // Customize cell
        dayCustomCell!.setTextColor(forState: cellState)
        dayCustomCell!.setSelection(forState: cellState)
        
        // Scroll to out month
        if (cellState.dateBelongsTo != .thisMonth ) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            
            if (Int(dateFormatter.string(from: date))! >= 25) {
                self.calendarView.scrollToSegment(.previous) {
                    self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                        self.calculatedDate = self.calculatedDate.previousMonth()
                        self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
                    }
                }
            } else {
                self.calendarView.scrollToSegment(.next) {
                    self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                        self.calculatedDate = self.calculatedDate.nextMonth()
                        self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
                    }
                }
            }
        }
        
        if firstDate != nil {
            calendarView.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            firstDate = nil
        } else {
            firstDate = date
            calendarView.deselectDates(from: calendarView.selectedDates.first!, to: calendarView.selectedDates.last!, triggerSelectionDelegate: false)
            calendarView.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print(object: "\(#function) run in [line \(#line)]")
        
        guard let dayCustomCell = cell as? CalendarDayCellView else {
            return
        }
        
        // Customize cell
        dayCustomCell.setTextColor(forState: cellState)
        dayCustomCell.setSelection(forState: cellState)
    }
    */
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print(object: "\(#function) run in [line \(#line)]")
        
        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.calculatedDate = visibleDates.monthDates[10]
            self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
        }
    }
}
