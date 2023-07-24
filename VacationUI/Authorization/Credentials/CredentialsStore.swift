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
    
    private enum Constant {
        static let defaultStorage = EFStorageFactory<Credentials>.singleValueStorage.security
    }
    
    private let storage: AnyEFSingleValueStorage<Credentials>
    
    @Published private(set) var credentials: Credentials? {
        didSet {
            handleNewCreds(credentials)
        }
    }
    
    private init(
        credentials: Credentials?,
        storage: AnyEFSingleValueStorage<Credentials>
    ) {
        self.storage = storage
        self.credentials = credentials
        handleNewCreds(credentials)
    }
    
    static let shared: CredentialsStore = {
        let storage = Constant.defaultStorage
        let credentials = storage.restore()
        return CredentialsStore(
            credentials: credentials,
            storage: AnyEFSingleValueStorage(storage)
        )
    }()
    
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
        storage.save(credentials)
    }
    
    private func clearStorage() {
        storage.clear()
    }
}
