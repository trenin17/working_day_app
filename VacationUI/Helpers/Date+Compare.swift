import Foundation

extension Date {

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}

extension Date {
    
    static let secondInDay: TimeInterval = 24 * 3600
    
    static func calendarDate(year: Int, month: Int, day: Int) -> Date? {
        let component = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: year,
            month: month,
            day: day,
            hour: 0,
            minute: 0
        )
        if let date = Calendar.current.date(from: component) {
            return date
        }
        return nil
    }
//    
//    static func calendarDateWithDefault(year: Int, month: Int, day: Int, `default`: Date = Date()) -> Date {
//        var component = DateComponents()
//        component.year = year
//        component.month = month
//        component.day = day
//        return Calendar.current.date(from: component) ?? `default`
//    }
//    
//    static func convertDateFormat(inputDate: String) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.date(from: inputDate)
//    }
    
    
    
}
