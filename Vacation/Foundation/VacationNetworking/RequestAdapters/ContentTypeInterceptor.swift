import Foundation
import Alamofire

final class JsonContentTypeRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.contentType("application/json"))
        completion(.success(urlRequest))
    }
}
