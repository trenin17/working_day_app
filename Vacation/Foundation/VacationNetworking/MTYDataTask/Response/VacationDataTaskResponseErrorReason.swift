import Foundation

enum VacationDataTaskResponseErrorReason: Error {
    case decodeFail
    case noSuchCodeHandler
    case unableToIdentifyStatusCode
    case emptyBody
    case unknown
}
