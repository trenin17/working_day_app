import SwiftUI
import Combine

struct EmployeeListView: View {
    
    @ObservedObject var store: EmployeeListStore
    let profileContainer: ProfileContainer
    
    var body: some View {
        NavigationStack {
            VStack {
                navigation
                VStack {
                    searchBar
                    viewForState
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    var viewForState: some View {
        switch store.state {
        case .loading:
            ProgressView()
        case .error:
            Text("Что-то пошло не так").foregroundColor(.red)
        case .loaded(let viewModel):
            mainView(for: viewModel)
        }
    }
    
    var navigation: some View {
        TopNavigationView()
            .text("Сотрудники")
            .trailView {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.blue)
            }
    }
    
    func mainView(for list: EmployeeList) -> some View {
        VStack(spacing: 5) {
            employeeList(for: list)
                .refreshable {
                    store.refresh()
                }
        }
    }
    
    var searchBar: some View {
        TextField("Поиск", text: $store.filter)
            .autocorrectionDisabled(true)
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 6))
            .background(Color(uiColor: .systemGray5))
            .cornerRadius(8)
            .padding([.leading, .trailing], 5)
    }
    
    func employeeList(for list: EmployeeList) -> some View {
        ScrollView(showsIndicators: false) {
            Color.clear.frame(height: 25)
            LazyVStack(spacing: 15) {
                ForEach(list.employees, id: \.id) { employeeItem in
                    NavigationLink(
                        destination: prepareDestination(for: employeeItem),
                        label: {
                            EmployeeListItemView(viewModel: employeeItem)
                        }
                    )
                }
            }
        }
    }
    
    private func prepareDestination(for item: EmployeeListItem) -> some View {
        profileContainer
            .eitherProfile(for: item.id)
            .navigationBarBackButtonHidden(true)
    }
}

struct EmployeeListView_Previews: PreviewProvider {
    
    static var previews: some View {
        EmployeeListView(
            store: store,
            profileContainer: ProfileContainer(
                manager: .default,
                credentialsStore: .shared
            )
        )
    }
    
    static var employees: [EmployeeListItem] = {
        [
            .init(
                id: "ivan",
                avatarURL: "https://preview.redd.it/this-person-does-not-exist-v0-9l5x3d2g21591.jpg?width=640&crop=smart&auto=webp&s=4f2cf32ea788e3ecf10354c2bf2709c1f8ffef4e",
                name: "Иван Иванов",
                badge: nil
            ),
            .init(
                id: "alex",
                avatarURL: "https://i.seadn.io/gae/7KTZ107oTbcCCWSs8M76vYd1b7gwth5AdHn6KR1HlfTxF0jgZugiVx6CdmYNw4OBtFJDNgQEizIkHzD5TUVmux0ppHGA-Ei5eG8k8Q?auto=format&dpr=1&w=1000",
                name: "Александр Захаров",
                badge: nil
            ),
            .init(
                id: "zuev",
                avatarURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHWaCjKO5DGT1_RiGlIOW5H5Uh7z7O7nXLhA&usqp=CAU",
                name: "Никита Зуев",
                badge: nil
            ),
            .init(
                id: "elizarova",
                avatarURL: "https://artlo.ru/wp-content/uploads/2021/05/mariya-elizarova.png",
                name: "Мария Елизарова",
                badge: 1
            ),
            .init(
                id: "panaf",
                avatarURL: "https://i.imgur.com/KSrujp9.jpg",
                name: "Егор Панафидин",
                badge: nil
            ),
            .init(
                id: "serg_01",
                avatarURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVSEwsHWUEZaNo7pnPKINwQWz9poTJOx-Qyg&usqp=CAU",
                name: "Алексей Сергеев",
                badge: nil
            )
        ]
    }()
    
    static let store = EmployeeListStore(mock_employees: employees)
}
