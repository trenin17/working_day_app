import SwiftUI
import FSCalendar
import EFNetwork

class TimezonedFSCalendar: FSCalendar {

   override init(frame: CGRect) {
      super.init(frame: frame)
   }

   required init?(coder aDecoder: NSCoder) {

       super.init(coder: aDecoder)

       if let projectTimeZone = TimeZone(identifier: "UTC") {
          self.setValue(projectTimeZone, forKey: "timeZone")
          self.perform(Selector(("invalidateDateTools")))
       }
   }
}

class FSCalendarDataSourceAdapter: NSObject, FSCalendarDataSource {
    
    var actions: VacationUserActions
    
    init(actions: VacationUserActions) {
        self.actions = actions
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        guard let circle = UIImage(systemName: "circlebadge.fill")?.withRenderingMode(.alwaysOriginal) else {
            return nil
        }
        var color: UIImage? = nil
        for action in actions.actions {
            if action.start <= date && date <= action.end {
                switch action.type {
                case .illness:
                    color = circle.withTintColor(.red)
                case .abscence:
                    color = circle.withTintColor(.yellow)
                case .vacation:
                    color = circle.withTintColor(.blue)
                case .attendance:
                    color = circle.withTintColor(.green)
                case .unknown:
                    color = nil
                }
            }
        }
        
        if color == nil {
            print("\(date.description) - nil")
        } else {
            print("\(date.description) - some color")
        }
        
        return color
    }
    
    //            date.description == "2023-07-24 21:00:00 +0000" || date.description == "2023-07-07 21:00:00 +0000"
    

}

struct FSCalnderApater: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    let fsCalendarView = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
    let dataSource: FSCalendarDataSourceAdapter
    
    init(
        actions: VacationUserActions
    ) {
        self.dataSource = FSCalendarDataSourceAdapter(actions: actions)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        fsCalendarView.dataSource = dataSource
        fsCalendarView.firstWeekday = 2
        if let projectTimeZone = TimeZone(identifier: "UTC") {
            fsCalendarView.setValue(projectTimeZone, forKey: "timeZone")
            fsCalendarView.perform(Selector(("invalidateDateTools")))
        }
        return fsCalendarView
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
    }
    
    func callUpdate(with actions: VacationUserActions) -> Self {
        dataSource.actions = actions
        fsCalendarView.reloadData()
        return self
    }
    
}
