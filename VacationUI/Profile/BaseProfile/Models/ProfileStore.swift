import Foundation
import EFNetwork

struct CommonDomainError: Error {
    let reason: String
}

struct ProfileFetchOperation {
    
    let networkManager: EFNetworkManager
    let profileId: String
    
    func perform() async -> Result<ProfileData, CommonDomainError> {
        return await networkManager
            .getAsync(url: "\(GlobalConstants.baseURL)/v1/employee/info?employee_id=\(profileId)")
            .handle(statusCode: 200, of: EmployeeResponseSuccess.self, completion: handleSuccess)
            .fallbackDetail { data in
                let code = data.response?.statusCode.description ?? "неизвестен"
                return .failure(CommonDomainError(reason: "Неизвестная ошибка. Код \(code)"))
            }
    }
    
    private func handleSuccess(response: EmployeeResponseSuccess) -> Result<ProfileData, CommonDomainError> {
        let viewModel = ProfileData(
            userInfo: UserInfo(
                id: response.id,
                username: "\(response.surname) \(response.name)",
                avatarURL: response.photoLink,
                phone: response.phone,
                email: response.email,
                birthday: response.birthday
            ),
            buttons: []
        )
        return .success(viewModel)
    }
}

class ProfileStore: ObservableObject {
    
    enum State {
        case empty
        case loading
        case loaded(ProfileData)
        case error(message: String)
    }
    
    @Published var viewState: State = .empty
    let networkManager: EFNetworkManager
    let credentialsStore: CredentialsStore
    private let id: String
    
    init(
        networkManager: EFNetworkManager,
        id: String,
        credentialsStore: CredentialsStore = .shared
    ) {
        self.networkManager = networkManager
        self.id = id
        self.credentialsStore = credentialsStore
    }
    
    init(
        viewModel: ProfileData,
        credentialsStore: CredentialsStore = .shared,
        networkManager: EFNetworkManager = EFNetworkManager.default
    ) {
        self.id = "hardcode"
        self.networkManager = networkManager
        self.credentialsStore = credentialsStore
        self.viewState = .loaded(viewModel)
    }
    
    func fetchIfNeeded() {
        switch viewState {
        case .empty:
            fetch()
        case .loading:
            return
        case .loaded:
            fetch()
        case .error:
            fetch()
        }
    }
    
    func fetch() {
        Task {
            let operation = ProfileFetchOperation(networkManager: networkManager, profileId: id)
            let result = await operation.perform()
            
            var newState: State
            switch result {
            case .success(let profileData):
                newState = .loaded(profileData)
            case .failure(let error):
                newState = .error(message: error.reason)
            }
            
            await MainActor.run { [newState] in
                self.viewState = newState
            }
        }
    }
    
    func exit() {
        credentialsStore.updateCredentials(nil)
    }
}

struct EmployeeResponseSuccess: Decodable {
    let id: String
    let name: String
    let surname: String
    let phone: String?
    let email: String?
    let birthday: String?
    let photoLink: String?
    let password: String?
    let headId: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
        case phone = "phone"
        case email = "email"
        case birthday = "birthday"
        case photoLink = "photo_link"
        case password = "password"
        case headId = "head_id"
    }
}   
