import Foundation

protocol VacationAsyncRequestHandlerProtocol {
    associatedtype ReturnType
    var statusCode: Int { get }
    func handleIfAvailable(response: VacationDataTaskResponse) async throws -> ReturnType
}

class VacationAsyncRequestHandler<ResponseBody: Decodable, ReturnType>: VacationAsyncRequestHandlerProtocol {
    let statusCode: Int
    let callBack: VacationCallback<ResponseBody, ReturnType>
    
    init(
        statusCode: Int,
        callback: VacationCallback<ResponseBody, ReturnType>
    ) {
        self.statusCode = statusCode
        self.callBack = callback
    }
    
    func handleIfAvailable(response: VacationDataTaskResponse) async throws -> ReturnType {
        // TODO: - support custom converters ...
        guard
            response.statusCode == statusCode,
            let body = try? JSONDecoder().decode(ResponseBody.self, from: response.body)
        else {
            throw VacationDataTaskResponseErrorReason.decodeFail
        }
        
        return await callBack.asyncCall(body)
    }
}
