import Foundation
import Combine
import EFStorage

struct Credentials: Codable {
    enum Role: String, Codable {
        case admin
        case user
    }
    
    let id: String
    let token: String
    let role: Role
}

protocol CredentialsPersistentStorage {
    var token: String? { get set }
    var role: String? { get set }
    var id: String? { get set }
}

class CredentialsStore: ObservableObject {
    
    private static let storage = EFStorageFactory<Credentials>.singleValueStorage.security
    
    @Published private(set) var credentials: Credentials? {
        didSet {
            handleNewCreds(credentials)
        }
    }
    
    private init(credentials: Credentials?) {
        self.credentials = credentials
        handleNewCreds(credentials)
    }
    
    static let shared = CredentialsStore(
        credentials: CredentialsStore.storage.restore()
    )
    
    func updateCredentials(_ credentials: Credentials?) {
        DispatchQueue.main.async {
            self.credentials = credentials
        }
    }
    
    private func handleNewCreds(_ credentials: Credentials?) {
        guard let credentials = credentials else {
            clearStorage()
            return
        }
        CredentialsStore.storage.save(credentials)
    }
    
    private func clearStorage() {
        CredentialsStore.storage.clear()
    }
}
