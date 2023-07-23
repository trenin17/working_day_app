import Foundation
import Combine
import EFNetwork

struct AuthorizationRequest: Encodable {
    let login: String
    let password: String
}

struct AuthorizationResponseSuccess: Decodable {
    
    enum Role: String, Decodable {
        case admin = "admin"
        case user = "user"
    }
    let token: String
    let role: Role
}

public typealias CommonErrorMessage = String

class AuthorizationService: ObservableObject {
    
    enum State {
        case requestNotSent
        case requestSent
        case authorizedSuccess(AuthorizationResponseSuccess)
        case failure(reason: String)
    }
    
    @Published var state: State
    private var networkManager = EFNetworkManager.default
    
    func authorize(data: AuthorizationRequest) {
        self.state = .requestSent
        Task {
            await makeAuthorizationRequest(data: data)
        }
    }
    
    private func makeAuthorizationRequest(data: AuthorizationRequest) async {
        await networkManager
            .postAsync(url: "\(GlobalConstants.baseURL)/v1/authorize", body: data)
            .handle(statusCode: 200, of: AuthorizationResponseSuccess.self) { response in
                await MainActor.run {
                    self.state = .authorizedSuccess(response)
                }
            }
            .handle(statusCode: 404, of: CommonErrorMessage.self) { reason in
                await MainActor.run {
                    self.state = .failure(reason: reason)
                }
            }
            .fallback {
                await MainActor.run {
                    self.state = .failure(reason: "Неизвестная ошибка. Повторите попытку позже")
                }
            }
    }
    
    init() {
        self.state = .requestNotSent
    }
}
