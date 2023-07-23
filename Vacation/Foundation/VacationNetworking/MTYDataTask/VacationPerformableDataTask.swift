import Foundation

struct VacationPerformableDataTask<ReturnType> {
    let handlers: [VacationAnyAsyncRequestHandler<ReturnType>]
    let fallback: VacationCallback<VacationDataTaskResponseError, ReturnType>

    init(
        handlers: [VacationAnyAsyncRequestHandler<ReturnType>],
        fallback: VacationCallback<VacationDataTaskResponseError, ReturnType>
    ) {
        self.handlers = handlers
        self.fallback = fallback
    }
    
    func accept(result: Result<VacationDataTaskResponse, VacationDataTaskResponseError>) async -> ReturnType  {
        switch result {
        case .success(let response):
            return await finish(with: response)
        case .failure(let error):
            return await finish(with: error)
        }
    }
    
    private func finish(with response: VacationDataTaskResponse) async -> ReturnType {
        do {
            return try await handle(response: response)
        } catch {
            return await handleFallback(response: response, error: error)
        }
    }
    
    private func finish(with error: Error) async -> ReturnType {
        return await handleFallback(response: nil, error: error)
    }
    
    private func handle(response: VacationDataTaskResponse) async throws -> ReturnType {
        guard let handler = handlers.first(
            where: { $0.statusCode == response.statusCode }
        ) else {
            throw VacationDataTaskResponseErrorReason.noSuchCodeHandler
        }
        
        return try await handler.handleIfAvailable(response: response)
    }
    
    private func handleFallback(
        response: VacationDataTaskResponse?,
        error: Error
    ) async -> ReturnType {
        var reason: Error = VacationDataTaskResponseErrorReason.unknown
        if let errorReason = error as? VacationDataTaskResponseErrorReason {
            reason = errorReason
        }
        if let readyError = error as? VacationDataTaskResponseError {
            reason = readyError.reason
        }
        
        return await fallback.asyncCall(
            VacationDataTaskResponseError(
                statusCode: response?.statusCode,
                body: response?.body,
                reason: reason
            )
        )
    }
}
