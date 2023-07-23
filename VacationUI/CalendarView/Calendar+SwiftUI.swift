import Foundation
import SwiftUI

struct DateComponentAsSingleDateComparator {
    
    func lessOrEqual(lhs: DateComponents, rhs: DateComponents) -> Bool! {
        let left = lhs.year! * 1000 + lhs.month! * 100 + lhs.day!
        let right = rhs.year! * 1000 + rhs.month! * 100 + rhs.day!
        return left <= right
    }
    
    func greaterOrEqual(lhs: DateComponents, rhs: DateComponents) -> Bool! {
        let left = lhs.year! * 1000 + lhs.month! * 100 + lhs.day!
        let right = rhs.year! * 1000 + rhs.month! * 100 + rhs.day!
        return left >= right
    }
    
}

struct VacationDateRange {
    let dateStart: Date
    let dateFinished: Date
    let color: UIColor
    
    func inside(date: Date) -> Bool {
        guard
            let start = dateToInt(date: dateStart),
            let finish = dateToInt(date: dateFinished),
            let dateValue = dateToInt(date: date)
        else {
            return false
        }
        return start <= dateValue && dateValue <= finish
    }
    
    private func dateToInt(date: Date) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return Int(formatter.string(from: date))
    }
}

class CalendarCustomDelegate: NSObject, UICalendarViewDelegate {
    
    var range: VacationDateRange
    
    init(range: VacationDateRange) {
        self.range = range
    }
    
    func calendarView(
        _ calendarView: UICalendarView,
        decorationFor dateComponents: DateComponents
    ) -> UICalendarView.Decoration? {
        guard
            let day = dateComponents.day,
            let month = dateComponents.month,
            let year = dateComponents.year,
            let date = Date.calendarDate(year: year, month: month, day: day)
        else {
            return nil
        }
        return range.inside(date: date) ? .default(color: range.color) : nil
    }
    
    func updateRange(_ newRange: VacationDateRange) {
        self.range = newRange
    }
}

struct CalendarSwiftUI: UIViewRepresentable {
    
    private var delegate: CalendarCustomDelegate
    private let range: VacationDateRange
    
    init(range: VacationDateRange) {
        self.range = range
        self.delegate = CalendarCustomDelegate(range: range)
    }

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.wantsDateDecorations = true
        view.delegate = delegate
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        delegate.updateRange(range)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            uiView.delegate = delegate
            uiView.reloadDecorations(forDateComponents: reloadableComponents(), animated: true)
        }
    }
    
    private func reloadableComponents() -> [DateComponents] {
        var dates: [Date] = [range.dateStart]
        var currentDate = range.dateStart + Date.secondInDay
        while currentDate < range.dateFinished {
            dates.append(currentDate)
            currentDate += Date.secondInDay
        }
        dates.append(range.dateFinished)
        return dates.map { date in
            DateComponents(
                calendar: .current,
                year: Calendar.current.component(.year, from: date),
                month: Calendar.current.component(.month, from: date),
                day: Calendar.current.component(.day, from: date)
            )
        }.removeDuplicates()
    }

}


//
//
//
//

