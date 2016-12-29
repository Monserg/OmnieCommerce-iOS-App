//
//  CalendarViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    // MARK: - Properties
    typealias HandlerSelectNewDateCompletion = ((_ newDate: Date) -> ())

    var handlerSelectNewDateCompletion: HandlerSelectNewDateCompletion?

    let firstDayOfWeek: DaysOfWeek = .monday
    var selectedDate: Date?
    var calculatedDate = Date()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet var weekdayLabelsCollection: [CustomLabel]!
    @IBOutlet weak var bottomDottedBorderView: DottedBorderView!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var fromTimeLabel: CustomLabel!
    @IBOutlet weak var toTimeLabel: CustomLabel!
    @IBOutlet weak var confirmButton: CustomButton!

    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        super.viewDidLoad()
        
        // Delegates
        calendarView.dataSource = self
        calendarView.delegate = self
        
        // Register DayCellView from XIB
        calendarView.registerCellViewXib(file: "CalendarDayCellView")
        
        // Setup cells insets
        calendarView.cellInset = CGPoint(x: 10, y: 5)
        setupCalendarView()
        setupSelectedDate()
        setupTitleLabel(withDate: selectedDate ?? Date())
        showSelectedDate(withDate: selectedDate ?? Date())
        
        // Add Calendar scrolling
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        
        calendarView.scrollToDate(Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    func setupCalendarView() {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        // Set weekday symbols
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        var weekdaySymbols = Array<String>()
        var count: Int = 0
        
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
            
            $0.attributedText = NSAttributedString(string: $0.text!.uppercaseFirst, attributes: UIFont.ubuntuLightDarkCyan16)
        })
    }
    
    func setupTitleLabel(withDate date: Date) {
        titleLabel.text = date.convertToString(withStyle: .MonthYear)
    }
    
    func setupSelectedDate() {
        selectedDate = (arc4random_uniform(2) == 1) ? Calendar.current.date(byAdding: .day, value: 5, to: Date())! : Date()
        
        guard selectedDate != nil else {
            return
        }
        
        setupTitleLabel(withDate: selectedDate!)
        calendarView.selectDates([selectedDate!], triggerSelectionDelegate: false)
        handlerSelectNewDateCompletion!(selectedDate!)
    }
    
    func redraw() {
        guard bottomDottedBorderView != nil else {
            return
        }
        
        bottomDottedBorderView.setNeedsDisplay()
        confirmButton.setupWithStyle(.Fill)
    }

    func showSelectedDate(withDate date: Date) {
        dateLabel.text = date.convertToString(withStyle: .Date)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                self.calculatedDate = self.calculatedDate.previousMonth()
                self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
            }
        }
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                self.calculatedDate = self.calculatedDate.nextMonth()
                self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
            }
        }
    }
    
    @IBAction func handlerConfirmButtonTap(_ sender: CustomButton) {
        print("\(type(of: self)): \(#function) run.")
    }
    
    @IBAction func handlerCancelButtonTap(_ sender: CustomButton) {
        print("\(type(of: self)): \(#function) run.")
    }
}


// MARK: - JTAppleCalendarViewDataSource
extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        let startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date(), wrappingComponents: false)!
        let endDate = Calendar.current.date(byAdding: .month, value: 12, to: Date(), wrappingComponents: false)!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: firstDayOfWeek)
        
        return parameters
    }
}


// MARK: - JTAppleCalendarViewDelegate
extension CalendarViewController: JTAppleCalendarViewDelegate {
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
        
        selectedDate = date
        showSelectedDate(withDate: selectedDate!)
        
        handlerSelectNewDateCompletion!(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("\(#function) run in [line \(#line)]")
        
        guard let dayCustomCell = cell as? CalendarDayCellView else {
            return
        }
        
        // Customize cell
        dayCustomCell.setTextColor(forState: cellState)
        dayCustomCell.setSelection(forState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print("\(#function) run in [line \(#line)]")
        
        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.calculatedDate = visibleDates.monthDates[10]
            self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
        }
    }
}
