import Foundation
import Alamofire

public final class VacationSession {
    
//    public init(
//        credentials: VacationJWTCredential
//    ) {
//        let authenticator = VacationJWTAuthenticator(
//            storage: VacationStorageFactory<VacationJWTCredential>.makeSecurityStorage()
//        )
//        let authInterceptor = AuthenticationInterceptor(
//            authenticator: authenticator,
//            credential: credentials
//        )
//        let composite = Interceptor(
//            adapters: [JsonContentTypeRequestAdapter()],
//            retriers: [],
//            interceptors: [authInterceptor]
//        )
//        self.session = Session(interceptor: composite)
//    }
    
    public static let unAuthorizedSession = VacationSession(session: Session())
    
    private init(session: Session) {
        self.session = session
    }
    
    //MARK: - Private
    
    private(set) var session: Session
    
    internal func logRequest(request: DataRequest) {
        request.responseData { opertaion in
            var logInfo: [String: Any] = [
                "url": opertaion.request?.url?.absoluteURL ?? "unknown url",
                "parameters": opertaion.request?.httpBody?.prettyPrintedJSONString ?? "unkown response"
            ]
            switch opertaion.result {
            case .success(let data):
                logInfo["response"] = data.prettyPrintedJSONString
            case .failure(let error):
                logInfo["response"] = error.localizedDescription
            }
            VacationLogger.shared.debug(
                "Reuqest send",
                context: logInfo
            )
        }
        
    }
    
    private func prettyPayloadDescription<Payload: Encodable>(payload: Payload) -> NSString {
        let data = try? JSONEncoder().encode(payload)
        return data?.prettyPrintedJSONString ?? "unable to represent json"
    }
}


