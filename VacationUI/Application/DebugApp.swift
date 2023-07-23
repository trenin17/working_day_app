import SwiftUI
import Combine

struct VacationUIAppDebug: View {
    
    @ObservedObject var store: CredentialsStore = .mockUnauthorized
    var disposeBag = Set<AnyCancellable>()
    
    init(store: CredentialsStore) {
        self.store = store
    }
    
    var body: some View {
        if store.credentials != nil {
            MainTabBarExample()
        } else {
            LoginView(credentialsStore: store)
        }
    }
}


class EnvironmentService<T>: ObservableObject {
    let serivce: T
    
    init(serivce: T) {
        self.serivce = serivce
    }
}
