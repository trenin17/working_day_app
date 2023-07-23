import Foundation
import Alamofire

public class VacationDataRequest {
    
    public struct FallbackData {
        public var data: Data?
        public let statusCode: Int?
    }
    
    public typealias FallbackCompletion = ((FallbackData) -> Void)
    
    // MARK: - Init
    
    init(
        dataRequest: DataRequest
    ) {
        self.dataRequest = dataRequest
        self.finalized = false
        self.handlersProcessing = 0
        self._fallbackCompletion = nil
    }
    
    // MARK: - Internal
    
    let dataRequest: DataRequest
    var finalized: Bool
    
    // MARK: - Private
    
    private var _fallbackCompletion: VacationCallback<FallbackData, Void>?
    private var handlersProcessing: Int {
        willSet {
            lock.lock()
        }
        didSet {
            lock.unlock()
            checkFallback()
        }
    }
    
    private let lock = NSLock()
    
    // MARK: - Public methods
    
    public func responseDecodable<T: Decodable>(
        statusCode: Int,
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>
            .defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>
            .defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>
            .defaultEmptyRequestMethods,
        completionHandler: @escaping (T) async -> Void
    ) -> Self {
        _responseDecodable(
            statusCode: statusCode,
            of: type,
            queue: queue,
            dataPreprocessor: dataPreprocessor,
            decoder: decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyRequestMethods,
            completionHandler: VacationCallback<T, Void>.async(completionHandler)
        )
    }
    
    public func responseDecodable<T: Decodable>(
        statusCode: Int,
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>
            .defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>
            .defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>
            .defaultEmptyRequestMethods,
        completionHandler: @escaping (T) -> Void
    ) -> Self {
        _responseDecodable(
            statusCode: statusCode,
            of: type,
            queue: queue,
            dataPreprocessor: dataPreprocessor,
            decoder: decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyRequestMethods,
            completionHandler: VacationCallback<T, Void>.default(completionHandler)
        )
    }
    
    public func fallback(_ completion: @escaping (FallbackData) -> Void) {
        _fallback(VacationCallback<FallbackData, Void>.default(completion))
    }
    
    public func fallback(_ completion: @escaping (FallbackData) async -> Void) {
        _fallback(VacationCallback<FallbackData, Void>.async(completion))
    }
    
    // MARK: - Private methods
    
    private func checkFallback() {
        _fallbackCompletion.flatMap { _fallback($0) }
    }
    
    private func _responseDecodable<T: Decodable>(
        statusCode: Int,
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<T>
            .defaultDataPreprocessor,
        decoder: DataDecoder = JSONDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<T>
            .defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<T>
            .defaultEmptyRequestMethods,
        completionHandler: VacationCallback<T, Void>
    ) -> Self {
        handlersProcessing += 1
        guard !finalized else {
            handlersProcessing -= 1
            return self
        }
        dataRequest
            .responseDecodable(
            of: type,
            queue: queue,
            dataPreprocessor: dataPreprocessor,
            decoder: decoder,
            emptyResponseCodes: emptyResponseCodes,
            emptyRequestMethods: emptyRequestMethods
        ) { response in
            guard
                let responseStatusCode = response.response?.statusCode,
                responseStatusCode == statusCode
            else {
                self.handlersProcessing -= 1
                return
            }
            switch response.result {
            case .success(let data):
                completionHandler.call(data)
                self.finalized = true
                self.handlersProcessing -= 1
            case .failure:
                self.handlersProcessing -= 1
                return
            }
        }
        return self
    }
    
    private func _fallback(_ completion: VacationCallback<FallbackData, Void>) {
        self._fallbackCompletion = completion
        if !finalized, handlersProcessing == 0 {
            dataRequest.responseData { response in
                var fallbackData = FallbackData(
                    data: nil,
                    statusCode: response.response?.statusCode
                )
                switch response.result {
                case .success(let data):
                    fallbackData.data = data
                case .failure:
                    fallbackData.data = nil
                }
                completion.call(fallbackData)
            }
            finalized = true
        } else {
            return
        }
    }
}
