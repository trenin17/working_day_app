import Foundation
import EFNetwork

struct NetworkManagerFactory {
    var credentialsStore: CredentialsStore
    
    func makeManager() -> EFNetworkManager {
        return EFNetworkManager(
            session: URLSession.shared,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors
        )
    }
    
    var requestInterceptors: [EFRequestInterceptor] {
        guard let creds = credentialsStore.credentials else { return [] }
        return [
            VacationAuthInterceptor(creds: creds),
        ]
    }
    
    var responseInterceptors: [EFResponseInterceptor] {
        [
            VacationUnauthorizedResponseInterceptor(
                store: credentialsStore
            )
        ]
    }
}

struct VacationAuthInterceptor: EFRequestInterceptor {
    let creds: Credentials
    
    public func intercept(request: URLRequest) -> URLRequest {
        var copy = request
        copy.setValue("Bearer \(creds.token)", forHTTPHeaderField: "Authorization")
        return copy
    }
}

struct VacationUnauthorizedResponseInterceptor: EFResponseInterceptor {
    
    let store: CredentialsStore
    let failureCodes: Set<Int> = .init(arrayLiteral: 401, 403)
    
    public func intercept(response: HTTPURLResponse?) -> Bool {
        guard let response else { return true }
        if failureCodes.contains(response.statusCode) {
            store.updateCredentials(nil)
            return false
        }
        return true
    }

}
