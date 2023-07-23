import SwiftUI

struct NotificationModel {
    enum NotificationType {
        case vacationRequest
        case vacationApproved
        case unknown
    }
    let id: String
    let shouldShowBadge: Bool
    let avatarURL: String?
    let senderName: String?
    let text: String
    let buttons: [VacationNotificationView.NotificationButton]
}

struct NotificationsView: View {
    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var store: NotificationsStore
    
    var body: some View {
        VStack(spacing: 5) {
            navigationView
            Spacer().frame(height: 20)
            viewForState
            Spacer()
        }
        .onAppear {
            store.fetchIfNeeded()
        }
    }
    
    // MARK: = UI
    
    @ViewBuilder
    private var viewForState: some View {
        switch store.state {
        case .loaded(let notifications):
            ScrollView {
                LazyVStack {
                    ForEach(notifications, id: \.id) { notification in
                        VacationNotificationView()
                            .imageURL(notification.avatarURL)
                            .senderName(notification.senderName ?? "")
                            .text(notification.text)
                            .shouldShowBade(notification.shouldShowBadge)
                            .buttons(notification.buttons)
                    }
                    .offset(y: 10)
                    Spacer().frame(height: 10)
                }
            }
        case .loading, .initial:
            ProgressView()
        case .error(let description):
            Text(description)
        }
    }
    
    private var navigationView: some View {
        TopNavigationView()
            .leadView {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                    }
                )
            }
            .text("Уведомления")
    }
    
}

struct NotificationsView_Previews: PreviewProvider {
    
    static let store = NotificationsStore(
        mock_notifications: [
            .init(
                id: "1",
                shouldShowBadge: true,
                avatarURL: nil,
                senderName: .randomName,
                text: "Ваше заявление на отпуск принято",
                buttons: [
                    .init(text: "Документ", color: .blue, action: .tap({})),
                ]
            ),
            .init(
                id: "2",
                shouldShowBadge: true,
                avatarURL: .randomURL,
                senderName: .randomName,
                text: "Прошу отправить меня в оплачиваемый отпуск с 19.09.2023 по 29.09.2023",
                buttons: [
                    .init(text: "Принять", color: .green, action: .tap({})),
                    .init(text: "Отклонить", color: .red, action: .tap({})),
                ]
            ),
            .init(
                id: "3",
                shouldShowBadge: true,
                avatarURL: .randomURL,
                senderName: .randomName,
                text: "К сожалению, в отпуске вам отказано",
                buttons: []
            )
        ]
    )
    
    static var previews: some View {
        NotificationsView(store: store)
    }
}
