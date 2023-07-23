import SwiftUI
import EFNetwork

struct MainTabBarExample: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some View {
        TabView {
            calendarPage
            employeeListItem
            profileExample
        }
    }
    
    // MARK: - Profile
    
    var profileExample: some View {
        ProfileView(
            store: fakeProfileStore,
            viewMode: .myProfile
        )
        .tabItem {
            Label("Профиль", systemImage: "person.circle.fill")
        }
    }
    
    private var fakeProfileStore: ProfileStore {
        ProfileStore(
            viewModel: ProfileData(
                userInfo: UserInfo.init(
                    id: "trenin17",
                    username: "Trenin17",
                    avatarURL: String.randomURL,
                    phone: "+79999999999",
                    email: "trenin17@gmail.com",
                    birthday: nil
                ),
                buttons: []
            ),
            credentialsStore: CredentialsStore.mockAuthorized
        )
    }
    
    // MARK: - Employee List
    
    var employeeListItem: some View {
        EmployeeListView_Previews.previews
            .tabItem {
                Label("Сотрудники", systemImage: "person.3.fill")
            }
    }
    
    // MARK: - Calendar
    
    var calendarPage: some View {
        ProfileCalendar()
            .tabItem {
                Label("Календарь", systemImage: "calendar")
            }
    }
    
    // MARK: - For tests
    
}

struct MainTabBarExample_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarExample()
    }
}
