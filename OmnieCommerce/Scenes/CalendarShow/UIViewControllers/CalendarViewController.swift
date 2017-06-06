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
    
    @IBOutlet weak var titleLabel: UbuntuLightVeryLightGrayLabel!
    @IBOutlet var weekdayLabelsCollection: [UbuntuLightDarkCyanLabel]!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        super.viewDidLoad()
        
        // Setup Calendar view
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0

        setupCalendarView()
        
        // Add Calendar scrolling
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        
        calendarView.scrollToDate(Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
            
            // FIXME: - Add support first symbol upperCase
            $0.attributedText = NSAttributedString(string: $0.text!.uppercaseFirst, attributes: UIFont.ubuntuLightDarkCyan16)
        })
    }
    
    func setupTitleLabel(withDate date: Date) {
        titleLabel.text = date.convertToString(withStyle: .MonthYear)
    }
    
    func setupSelectedDate() {
        calendarView.selectDates([selectedDate!], triggerSelectionDelegate: false)
        handlerSelectNewDateCompletion!(selectedDate!)
    }
    
    // MARK: - Actions
    @IBAction func handlerPreviuosButtonTap(_ sender: UIButton) {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                if let date = visibleDates.monthDates.first?.date.globalTime() {
                    self.setupTitleLabel(withDate: date)
                }
            }
        }
    }
    
    @IBAction func handlerNextButtonTap(_ sender: UIButton) {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                if let date = visibleDates.monthDates.first?.date.globalTime() {
                    self.setupTitleLabel(withDate: date)
                }
            }
        }
    }    
}


// MARK: - JTAppleCalendarViewDataSource
extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("\(#file): \(#function) run in [line \(#line)]")
        
        let startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date(), wrappingComponents: false)!
        let endDate = Calendar.current.date(byAdding: .month, value: 12, to: Date(), wrappingComponents: false)!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: firstDayOfWeek)
        
        return parameters
    }
}


// MARK: - JTAppleCalendarViewDelegate
extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        cell.dateLabel.text = cellState.text
        cell.viewDidUpload(forCellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let calendarDayCell = cell as? CalendarDayCell {
            calendarDayCell.viewDidUpload(forCellState: cellState)
            selectedDate = cellState.date
        
            // Scroll to out month
            if (cellState.dateBelongsTo != .thisMonth ) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                
                if (Int(dateFormatter.string(from: date))! >= 25) {
                    self.calendarView.scrollToSegment(.previous) {
                        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                            if let date = visibleDates.monthDates.first?.date.globalTime() {
                                self.setupTitleLabel(withDate: date)
                            }
                        }
                    }
                } else {
                    self.calendarView.scrollToSegment(.next) {
                        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
                            if let date = visibleDates.monthDates.first?.date.globalTime() {
                                self.setupTitleLabel(withDate: date)
                            }
                        }
                    }
                }
            }
            
            handlerSelectNewDateCompletion!(date)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let calendarDayCell = cell as? CalendarDayCell {
            calendarDayCell.viewDidUpload(forCellState: cellState)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print("\(#function) run in [line \(#line)]")
        
        if let date = visibleDates.monthDates.first?.date {
            self.setupTitleLabel(withDate: date.globalTime())
        }
        
//        self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
//            self.calculatedDate = visibleDates.monthDates[10]
//            self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
//        }
    }

//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        let dayCustomCell = cell as? CalendarDayCellView
//        
//        guard dayCustomCell != nil else {
//            return
//        }
//        
//        // Customize cell
//        dayCustomCell!.setTextColor(forState: cellState)
//        dayCustomCell!.setSelection(forState: cellState)
//        
//        // Scroll to out month
//        if (cellState.dateBelongsTo != .thisMonth ) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd"
//            
//            if (Int(dateFormatter.string(from: date))! >= 25) {
//                self.calendarView.scrollToSegment(.previous) {
//                    self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
//                        self.calculatedDate = self.calculatedDate.previousMonth()
//                        self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
//                    }
//                }
//            } else {
//                self.calendarView.scrollToSegment(.next) {
//                    self.calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
//                        self.calculatedDate = self.calculatedDate.nextMonth()
//                        self.setupTitleLabel(withDate: self.calculatedDate.globalTime())
//                    }
//                }
//            }
//        }
//        
//        handlerSelectNewDateCompletion!(date)
//    }
//    
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        print("\(#function) run in [line \(#line)]")
//        
//        guard let dayCustomCell = cell as? CalendarDayCellView else {
//            return
//        }
//        
//        // Customize cell
//        dayCustomCell.setTextColor(forState: cellState)
////        dayCustomCell.selectedView.isHidden = true
//        dayCustomCell.setSelection(forState: cellState)
//    }
    
    
}
