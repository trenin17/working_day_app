import SwiftUI
import Foundation

struct ProfileCalendar_Prod: View {
    
    @Environment(\.dismiss) var dismiss
    
    private enum Constant {
        static let secondInDay: TimeInterval = 24 * 3600
    }
    
    @ObservedObject var store: ProfileCalendarStore
    
    @State var startDate: Date = Date.now - Constant.secondInDay * 2
    @State var endDate: Date = Date.now - Constant.secondInDay * 3
    let adapter = FSCalnderApater(actions: .init(actions: []))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 5) {
                navigationView
                viewForState()
            }
        }
        .onAppear {
            store.fetchState()
        }
    }
    
    @ViewBuilder
    func viewForState() -> some View {
        switch store.state {
        case .initial, .loading:
            VStack {
                ProgressView()
                Spacer()
            }
        case .loaded(let userActions):
            VStack {
                Spacer()
                buttons
                adapter
                    .callUpdate(with: userActions)
                Spacer()
            }
        case .error:
            Text("Что-то пошло не так")
                .foregroundStyle(Color.red)
        }
    }
    
    private var buttons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
//                navigation(title: "Отсутсвие", color: .yellow)
//                navigation(title: "Болезнь", color: .red)
                navigation(title: "Отпуск", color: .blue)
            }.padding(.leading, 40)
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
                    store: VacationRequestStore(
                        networkManager: store.networkManager,
                        calendarStore: store
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

struct ProfileCalendar_Prod_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCalendar_Prod(store: ProfileCalendarStore(networkManager: .default))
    }
}

