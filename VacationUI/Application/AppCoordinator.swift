import Foundation
import Combine

class AppCoordinator: ObservableObject {
    
    @Published var isAuthorized: Bool
    private(set) var credentialsStore = CredentialsStore.shared
    private var disposeBag = Set<AnyCancellable>()
    
    var networkManagerFactory: NetworkManagerFactory
    
    init() {
        self.isAuthorized = credentialsStore.credentials != nil
        self.networkManagerFactory = NetworkManagerFactory(credentialsStore: credentialsStore)
        credentialsStore
            .$credentials
            .receive(on: DispatchQueue.main)
            .sink { cred in
                self.isAuthorized = cred != nil
            }.store(in: &disposeBag)
    }
    
}
