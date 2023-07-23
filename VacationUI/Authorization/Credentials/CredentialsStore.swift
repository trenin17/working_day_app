import Foundation
import Combine

struct Credentials {
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

struct CredentialsUDStorage: CredentialsPersistentStorage {
    
    private enum Keys {
        static let id = "Vacation.Identifiers.Id"
        static let tokenStorageKey = "Vacation.Creds.Token"
        static let roleStorageKey = "Vacation.Creds.Role"
    }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.tokenStorageKey)
        }
        set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: Keys.tokenStorageKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: Keys.tokenStorageKey)
        }
    }
    var role: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.roleStorageKey)
        }
        set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: Keys.roleStorageKey)
                return
            }
            UserDefaults.standard.set(newValue, forKey: Keys.roleStorageKey)
        }
    }
    var id: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.id)
        }
        set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: Keys.id)
                return
            }
            UserDefaults.standard.set(newValue, forKey: Keys.id)
        }
    }
    
}

struct CredentialsMockAuthorizedStorage: CredentialsPersistentStorage {
    var token: String? = "Token hardcode"
    var role: String? = "admin"
    var id: String? = "id hardcode"
}

struct CredentialsMockUnAuthorizedStorage: CredentialsPersistentStorage {
    var token: String? = nil
    var role: String? = nil
    var id: String? = nil
}

class CredentialsStore: ObservableObject {
    
    @Published private(set) var credentials: Credentials? {
        didSet {
            handleNewCreds(credentials)
        }
    }
    
    private var storage: CredentialsPersistentStorage
    
    private init(credentials: Credentials?, storage: CredentialsPersistentStorage) {
        self.credentials = credentials
        self.storage = storage
        handleNewCreds(credentials)
    }
    
    static var shared: CredentialsStore = store(with: CredentialsUDStorage())
    
    private static func store(with storage: CredentialsPersistentStorage) -> CredentialsStore {
        guard let token = storage.token,
              let roleRaw = storage.role,
              let id = storage.id,
              let role = Credentials.Role(rawValue: roleRaw)
        else {
            return CredentialsStore(credentials: nil, storage: storage)
        }
        let creds = Credentials(id: id, token: token, role: role)
        return CredentialsStore(credentials: creds, storage: storage)
    }
    
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
        storage.token = credentials.token
        storage.role = credentials.role.rawValue
        storage.id = credentials.id
        
    }
    
    private func clearStorage() {
        storage.id = nil
        storage.role = nil
        storage.token = nil
    }
}

extension CredentialsStore {
    static var mockAuthorized: CredentialsStore = store(with: CredentialsMockAuthorizedStorage())
    static var mockUnauthorized: CredentialsStore = store(with: CredentialsMockUnAuthorizedStorage())
}
