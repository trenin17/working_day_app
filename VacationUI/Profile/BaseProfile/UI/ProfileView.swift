import SwiftUI

struct ProfileView: View {
    
    private enum TODO {
        static let mockFileURL = URL(
            string: "https://storage.yandexcloud.net/trenin17-results/test.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJEOdLm3qy7QLx1LoGsCeUL%2F20230613%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20230613T205035Z&X-Amz-Expires=86400&X-Amz-Signature=25E7D2B98B87DFB4BADD9F0B561DED36212D7FB33C2F687556861EACA4D6164E&X-Amz-SignedHeaders=host"
        )!
    }
    
    enum Mode {
        case myProfile
        case eitherEmployee
    }
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store: ProfileStore
    let viewMode: Mode
    @State var isPresentingDebugController: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                VStack {
                    switch store.viewState {
                    case .empty:
                        VStack(spacing: 5) {
                            loadingNavigation()
                            Spacer()
                            Color.clear.onAppear {
                                store.fetchIfNeeded()
                            }
                        }
                    case .loading:
                        VStack(spacing: 5) {
                            loadingNavigation()
                            ProgressView()
                            Spacer()
                        }
                    case .loaded(let profileDate):
                        makeLoadedView(for: profileDate).onAppear {
                            store.fetchIfNeeded()
                        }
                    case .error(let errorMessage):
                        VStack(spacing: 5) {
                            loadingNavigation()
                            Text(errorMessage)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    

    private func makeLoadedView(
        for viewModel: ProfileData
    ) -> some View {
        VStack(spacing: 5) {
            navigationView(for: viewModel)
            Spacer()
            UserInfoView(viewModel: viewModel.userInfo)
            Spacer().frame(height: 20)
            buttons(for: viewModel)
            Spacer()
        }
    }
    
    // MARK: - Top Navigation
    
    private func navigationView(
        for viewModel: ProfileData
    ) -> some View {
        TopNavigationView()
            .leadView {
                navigationLeadView(for: viewModel.userInfo.avatarURL)
            }
            .trailView {
                navigationTrailViewView(for: viewModel)
            }
            .text("Профиль сотрудника")
    }
    
    private func loadingNavigation() -> some View {
        TopNavigationView()
            .leadView { navigationLeadView(for: nil) }
            .text("Профиль сотрудника")
    }

    @ViewBuilder
    private func navigationLeadView(
        for avatarURL: String?
    ) -> some View {
        switch viewMode {
        case .myProfile:
            VacationAsyncImage(
                url: avatarURL
            )
            .clipShape(Circle())
        case .eitherEmployee:
            Image(systemName: "arrow.backward")
                .fontWeight(.bold)
                .foregroundColor(ColorPalette.activeControl)
                .onTapGesture { presentationMode.wrappedValue.dismiss() }
        }
    }
    
    @ViewBuilder
    private func navigationTrailViewView(
        for viewModel: ProfileData
    ) -> some View {
        switch viewMode {
        case .myProfile:
            NavigationLink(
                destination: {
                    EditProfileView(store: makeEditStore(for: viewModel))
                        .navigationBarBackButtonHidden(true)
                },
                label: {
                    Image(systemName: "pencil")
                        .fontWeight(.bold)
                        .foregroundColor(ColorPalette.activeControl)
                }
            )
        case .eitherEmployee:
            EmptyView()
        }
    }
    
    private func buttons(
        for viewModel: ProfileData
    ) -> some View {
        VStack(spacing: 10) {
            ForEach(viewModel.buttons, id: \.title) { button in
                ProfileButtonView(title: button.title) { print(button.title) }
            }
            switch viewMode {
            case .myProfile:
                myProfileButtons(for: viewModel)
            case .eitherEmployee:
                EitherEmployeeProfileButtonList(
                    store: ProfileCalendarStore(
                        networkManager: store.networkManager,
                        userId: viewModel.userInfo.id
                    )
                )
            }
        }
    }
    
    private func myProfileButtons(for viewModel: ProfileData) -> some View {
        VStack {
            notificationsButton(for: viewModel)
            exitButton
        }
    }
    
    private var exitButton: some View {
        ProfileButtonView(title: "Выйти") { store.exit() }
    }
    
    private func notificationsButton(
        for viewModel: ProfileData
    ) -> some View {
        NavigationLink(
            destination: {
                NotificationsView(
                    store: makeNotificationsStore(for: viewModel)
                )
                .navigationBarBackButtonHidden(true)
            },
            label: {
                ProfileButtonView(title: "Уведомления", action: nil)
            }
        )
    }
    
    private func makeEditStore(
        for viewModel: ProfileData
    ) -> EditProfileStore {
        EditProfileStore(
            viewModel: viewModel,
            networkManager: store.networkManager
        )
    }
    
    private func makeNotificationsStore(
        for viewModel: ProfileData
    ) -> NotificationsStore {
        NotificationsStore(
            networkManager: store.networkManager
        )
    }
    
    private func mock_eitherNotificationsStore() -> NotificationsStore {
        let finishedNotifications = [NotificationModel].init(
            arrayLiteral: .init(
                id: "1",
                shouldShowBadge: false,
                avatarURL: "https://artlo.ru/wp-content/uploads/2021/05/mariya-elizarova.png",
                senderName: "Мария Елизарова",
                text: "Прошу отправить меня в оплачиваемый отпуск с 19.09.2023 по 29.09.2023",
                buttons: []
            )
        )
        let notificationStore = NotificationsStore(mock_notifications: [])
        notificationStore.state = .loaded([
            .init(
                id: "1",
                shouldShowBadge: true,
                avatarURL: "https://artlo.ru/wp-content/uploads/2021/05/mariya-elizarova.png",
                senderName: "Мария Елизарова",
                text: "Прошу отправить меня в оплачиваемый отпуск с 19.09.2023 по 29.09.2023",
                buttons: [
                    .init(
                        text: "Принять",
                        color: .green,
                        action: .tap({ [notificationStore] in
                            notificationStore.state = .loaded(finishedNotifications)
                        })
                    ),
                    .init(
                        text: "Отклонить",
                        color: .red,
                        action: .tap({ [notificationStore] in
                            notificationStore.state = .loaded([])
                        })
                    ),
                ]
            )
        ])
        return notificationStore
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static let store = ProfileStore(
        viewModel: ProfileData(
            userInfo: UserInfo(
                id: .random,
                username: .randomName,
                avatarURL: .randomURL,
                phone: String?.random,
                email: String?.random,
                birthday: String?.random
            ),
            buttons: [
                ProfileData.Button(title: .random, badge: .random),
                ProfileData.Button(title: .random, badge: .random),
            ]
        )
    )
    static var previews: some View {
        ProfileView(
            store: store,
            viewMode: .myProfile
        )
    }
}



struct ProfileButtonView: View {
    let title: String
    let action: (() -> Void)?
    
    var body: some View {
        if let action {
            Button(action: action, label: { content })
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            ColorPalette.control
            Text(title)
                .foregroundColor(Color.black)
        }
        .frame(height: 35)
        .cornerRadius(10)
        .padding([.leading, .trailing], 15)
    }
}
