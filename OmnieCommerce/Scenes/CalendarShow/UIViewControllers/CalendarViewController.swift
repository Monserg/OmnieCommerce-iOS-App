//
//  CalendarViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 08.12.16.
//  Copyright © 2016 Omniesoft. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: BaseViewController {
    // MARK: - Properties
    typealias CompletionVoid = ((_ newDate: Date) -> ())

    var selectedDay: DayView!
    var changeMonthHandlerCompletion: CompletionVoid?

    @IBOutlet weak var calendarView: CVCalendarView!
    
    
    // MARK: - Class Functions
    override func viewDidLayoutSubviews() {
        print(object: "\(type(of: self)): \(#function) run.")
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
    }

    override func viewWillLayoutSubviews() {
        print(object: "\(type(of: self)): \(#function) run.")
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - CVCalendarViewDelegate
extension CalendarViewController: CVCalendarViewDelegate {
    // Required
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }

    // Optional
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }

    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
    }
    
    // Current day view
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = UIColor.clear
        circleView.strokeColor = (Config.Constants.isAppThemesLight) ? UIColor.green : UIColor.darkCyan
        
        return circleView
    }
    
    // Show / hide current day
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        
        return false
    }

    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blue
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter: CGFloat = (min(newView.bounds.width, newView.bounds.height)) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRect(x: newView.frame.midX-radius, y: newView.frame.midY-radius-ringVerticalOffset, width: diameter, height: diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = rect.insetBy(dx: ringLineWidthInset, dy: ringLineWidthInset)
        let centrePoint: CGPoint = CGPoint(x: ringRect.midX, y: ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }

    func shouldSelectRange() -> Bool {
        return false
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print(object: "RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func disableScrollingBeforeDate() -> Date {
        return Date()
    }
    
    func maxSelectableRange() -> Int {
        return 1
    }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 70
        let calendar = Calendar(identifier: .gregorian)
        
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        } else {
            return Date()
        }
    }
    
    // Change current month by switch gesture
    func didShowNextMonthView(_ date: Foundation.Date) {
        print(object: "\(type(of: self)): \(#function) run. Date = \(date)")
     
        changeMonthHandlerCompletion!(date.globalTime())
    }
    
    func didShowPreviousMonthView(_ date: Foundation.Date) {
        print(object: "\(type(of: self)): \(#function) run. Date = \(date)")
        
        changeMonthHandlerCompletion!(date.globalTime())
    }
    
    // Change current month by tap
    func shouldScrollOnOutDayViewSelection() -> Bool {
        print(object: "\(type(of: self)): \(#function) run.")
     
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: selectedDay.date.year, month: selectedDay.date.month, day: selectedDay.date.day)
        changeMonthHandlerCompletion!((Calendar.current.date(from: dateComponents)?.globalTime())!)
        
        return true
    }
}


// MARK: - CVCalendarViewAppearanceDelegate
extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    // Rendering options
    func spaceBetweenWeekViews() -> CGFloat {
        return 1
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 1
    }

    // Font options
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    func dayLabelWeekdayFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }

    func dayLabelPresentWeekdayFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    func dayLabelPresentWeekdayHighlightedFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    func dayLabelPresentWeekdaySelectedFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    func dayLabelWeekdayHighlightedFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    func dayLabelWeekdaySelectedFont() -> UIFont {
        return (Config.Constants.isAppThemesLight) ? UIFont.systemFont(ofSize: 14) : UIFont.ubuntuLight16
    }
    
    // Text color
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
        
        case (.sunday, .in, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
        
        case (.sunday, _, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryDarkGrayishBlue53
        
        case (_, .in, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
        
        default:
            return (Config.Constants.isAppThemesLight) ? UIColor.veryDarkGrayishBlue53 : UIColor.veryDarkGrayishBlue53
        }
    }

    func dayLabelWeekdayInTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }
    
    func dayLabelWeekdayOutTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryDarkGrayishBlue53 : UIColor.veryDarkGrayishBlue53
    }
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.clear
    }

    func dayLabelWeekdayHighlightedTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }
    
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }
    
    func dayLabelPresentWeekdayHighlightedTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }
    
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.veryLightGray : UIColor.veryLightGray
    }

    // Text size
    func dayLabelSize(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> CGFloat {
        return 16
    }

    func dayLabelWeekdayTextSize() -> CGFloat {
        return 16
    }

    func dayLabelWeekdayHighlightedTextSize() -> CGFloat {
        return 16
    }
    
    func dayLabelWeekdaySelectedTextSize() -> CGFloat {
        return 16
    }
    
    func dayLabelPresentWeekdayTextSize() -> CGFloat {
        return 16
    }
    
    func dayLabelPresentWeekdayHighlightedTextSize() -> CGFloat {
        return 16
    }
    
    func dayLabelPresentWeekdaySelectedTextSize() -> CGFloat {
        return 16
    }

    // Background Color & Alpha
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.black : UIColor.darkCyan
        
        case (_, .selected, _), (_, .highlighted, _):
            return (Config.Constants.isAppThemesLight) ? UIColor.black : UIColor.darkCyan
        
        default:
            return nil
        }
    }
    
    // Selected state background & alpha
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.blue : UIColor.darkCyan
    }
    
    func dayLabelWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return 1
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return (Config.Constants.isAppThemesLight) ? UIColor.blue : UIColor.darkCyan
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return 1
    }
}

