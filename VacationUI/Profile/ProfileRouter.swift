import Foundation
import SwiftUI
import EFNetwork


struct ProfileContainer {
    
    let manager: EFNetworkManager
    let credentialsStore: CredentialsStore
    
    func myProfile() -> ProfileView? {
        guard let credentials = credentialsStore.credentials else { return nil }
        let store = ProfileStore(
            networkManager: manager,
            id: credentials.id
        )
        return ProfileView(store: store, viewMode: .myProfile)
    }
    
    func eitherProfile(for id: String) -> ProfileView {
        let store = ProfileStore(networkManager: manager, id: id)
        let view = ProfileView(store: store, viewMode: .eitherEmployee)
        return view
    }
}
