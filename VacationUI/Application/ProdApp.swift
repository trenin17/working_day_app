import SwiftUI
import Combine


struct VacationUIAppProd: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        if coordinator.isAuthorized {
            MainTabBarProd()
                .environmentObject(EnvironmentService(serivce: coordinator.networkManagerFactory.makeManager()))
                .environmentObject(coordinator.credentialsStore)
        } else {
            LoginView(credentialsStore: coordinator.credentialsStore)
        }
    }
}
