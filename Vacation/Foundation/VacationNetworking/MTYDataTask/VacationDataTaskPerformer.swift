import Foundation
import Alamofire
    
struct VacationDataTaskPerformer {
    typealias TaskError = VacationDataTaskResponseError
    
    func perfrom(
        dataTask: DataTask<Data>
    ) async -> Result<VacationDataTaskResponse, VacationDataTaskResponseError> {
        
        async let responseP = await dataTask.response
        async let dataP = try? await dataTask.value
        let (response, data) = await (responseP, dataP)
        
        guard let statusCode = response.response?.statusCode else {
            return .failure(.noStatusCode(with: data))
        }
        
        guard let data = data else {
            return .failure(.noData(with: statusCode))
        }
        
        return .success(.init(statusCode: statusCode, body: data))
    }
}
