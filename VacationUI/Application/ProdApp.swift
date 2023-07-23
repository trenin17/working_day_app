import SwiftUI
import Combine

class EnvironmentService<T>: ObservableObject {
    let serivce: T

    init(serivce: T) {
        self.serivce = serivce
    }
}

struct VacationUIAppProd: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        if coordinator.isAuthorized {
            MainTabBar()
                .environmentObject(EnvironmentService(serivce: coordinator.networkManagerFactory.makeManager()))
                .environmentObject(coordinator.credentialsStore)
        } else {
            LoginView(credentialsStore: coordinator.credentialsStore)
        }
    }
}
