//
//  OrderCalendarShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 15.05.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import JTAppleCalendar

class OrderCalendarShowViewController: BaseViewController {
    // MARK: - Properties
    let firstDayOfWeek: DaysOfWeek = .monday
    var ordersDates: [Date]?
    var calculatedDate = Date()

    var handlerSelectNewDateCompletion: HandlerPassDataCompletion?

    // Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet var weekdayLabelsCollection: [UbuntuLightDarkCyanLabel]!
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        if let dates = ordersDates {
            calendarView.selectDates(dates, triggerSelectionDelegate: false)
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
    
    
    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        print(object: "\(#file): \(#function) run in [line \(#line)]")
        
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
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dayCustomCell = cell as! CalendarDayCellView
        
        // Setup Day
        dayCustomCell.setupBeforeDisplay(forDate: date, witState: cellState)
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
        
        handlerSelectNewDateCompletion!(date.globalTime())
        self.navigationController?.popViewController(animated: true)
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
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print(object: "\(#function) run in [line \(#line)]")
        
        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.calculatedDate = visibleDates.monthDates[10]
            self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
        }
    }
}
