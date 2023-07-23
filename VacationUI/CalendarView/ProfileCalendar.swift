import SwiftUI
import Foundation

struct ProfileCalendar: View {
    
    @Environment(\.dismiss) var dismiss
    
    private enum Constant {
        static let secondInDay: TimeInterval = 24 * 3600
    }
    
    @State var startDate: Date = Date.now - Constant.secondInDay * 2
    @State var endDate: Date = Date.now - Constant.secondInDay * 3
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 5) {
                navigationView
                Spacer()
                buttons
                CalendarSwiftUI(
                    range: .init(
                        dateStart: startDate,
                        dateFinished: endDate,
                        color: .blue
                    )
                )
                .fixedSize()
                Spacer()
            }
        }
    }
    
    private var buttons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
//                navigation(title: "Отсутсвие", color: .yellow)
//                navigation(title: "Болезнь", color: .red)
                navigation(title: "Отпуск", color: .blue)
            }
        }
    }
    
    private var navigationView: some View {
        TopNavigationView()
            .text("Календарь")
    }
    
    private func navigation(title: String, color: Color) -> some View {
        NavigationLink(
            destination: {
                VacationDateInervalSelector(
                    startDate: $startDate,
                    endDate: $endDate,
                    // TODO: - remove
                    store: VacationRequestStore(
                        networkManager: .default,
                        calendarStore: ProfileCalendarStore(networkManager: .default)
                    )
                )
            },
            label: {
                ProfileCalendarButton(title: title, color: color)
            }
        )
    }
    
    private struct ProfileCalendarButton: View {
        let title: String
        let color: Color
        
        var body: some View {
            Text(title)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
        }
    }
    
}

struct ProfileCalendar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCalendar()
    }
}

