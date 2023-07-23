//
//  File.swift
//  
//
//  Created by erokha on 18.09.2022.
//

import Foundation

class _VacationAnyAsyncRequestHandlerBox<ReturnType>: VacationAsyncRequestHandlerProtocol {
    var statusCode: Int {
        get { fatalError("abstract class methods shoud not be called") }
    }
    
    func handleIfAvailable(response: VacationDataTaskResponse) async throws -> ReturnType {
        fatalError("abstract class methods shoud not be called")
    }
}

class _VacationAsyncRequestHandlerBox<Base: VacationAsyncRequestHandlerProtocol>: _VacationAnyAsyncRequestHandlerBox<Base.ReturnType> {
    private let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
    override var statusCode: Int {
        return base.statusCode
    }
    
    override func handleIfAvailable(response: VacationDataTaskResponse) async throws -> Base.ReturnType {
        return try await base.handleIfAvailable(response: response)
    }
}

class VacationAnyAsyncRequestHandler<ReturnType>: VacationAsyncRequestHandlerProtocol {
   private let box: _VacationAnyAsyncRequestHandlerBox<ReturnType>
    
   init<HandlerType: VacationAsyncRequestHandlerProtocol>(_ handler: HandlerType)
      where HandlerType.ReturnType == ReturnType{
      
      box = _VacationAsyncRequestHandlerBox(handler)
   }
    
    var statusCode: Int {
        return box.statusCode
    }
    
    func handleIfAvailable(response: VacationDataTaskResponse) async throws -> ReturnType {
        return try await box.handleIfAvailable(response: response)
    }
}
