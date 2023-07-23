//
//  File.swift
//  
//
//  Created by erokha on 18.09.2022.
//

import Foundation
import Alamofire

public actor VacationDataTask<ReturnType> {
    private let dataTask: DataTask<Data>
    
    typealias Fallback = VacationCallback<VacationDataTaskResponseError, ReturnType>
    
    private var handlers: [VacationAnyAsyncRequestHandler<ReturnType>] = []
    
    init(_ dataTask: DataTask<Data>) {
        self.dataTask = dataTask
    }
    
    public func handler<ResponseBody: Decodable>(
        for statusCode: Int,
        of type: ResponseBody.Type = ResponseBody.self,
        shouldReturn: ReturnType.Type = ReturnType.self,
        _ closure: @escaping (ResponseBody) async -> ReturnType
    ) -> Self {
        let handler = VacationAsyncRequestHandler(statusCode: statusCode, callback: .async(closure))
        handlers.append(VacationAnyAsyncRequestHandler(handler))
        return self
    }
    
    public func fallback(
        shouldReturn: ReturnType.Type = ReturnType.self,
        _ closure: @escaping (VacationDataTaskResponseError) async -> ReturnType
    ) async -> ReturnType {
        let fallback = Fallback.async(closure)
        
        let result = await perform(with: fallback)
        return result
    }
    
    private func perform(with fallback: Fallback) async -> ReturnType {
        let performable = VacationPerformableDataTask(handlers: handlers, fallback: fallback)
        let result = await VacationDataTaskPerformer().perfrom(dataTask: dataTask)
        let response = await performable.accept(result: result)
        return response
    }
}


