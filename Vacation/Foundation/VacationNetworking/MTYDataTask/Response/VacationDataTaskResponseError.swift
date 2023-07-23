import Foundation

public struct VacationDataTaskResponseError: Error {
    let statusCode: Int?
    let body: Data?
    let reason: Error
    
    static func noStatusCode(with data: Data?) -> Self {
        VacationDataTaskResponseError(
            statusCode: nil,
            body: data,
            reason: VacationDataTaskResponseErrorReason.unableToIdentifyStatusCode
        )
    }
    
    static func noData(with code: Int) -> Self {
        VacationDataTaskResponseError(
            statusCode: code,
            body: nil,
            reason: VacationDataTaskResponseErrorReason.emptyBody
        )
    }
    
}
