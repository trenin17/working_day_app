import SwiftUI
import Combine


struct VacationUIAppProd {
    @ObservedObject var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            return currentView
        }
    }
    
    @ViewBuilder
    var currentView: some View {
        if coordinator.isAuthorized {
            MainTabBarProd()
                .environmentObject(EnvironmentService(serivce: coordinator.networkManagerFactory.makeManager()))
                .environmentObject(coordinator.credentialsStore)
        } else {
            LoginView(credentialsStore: coordinator.credentialsStore)
        }
    }
    
}
