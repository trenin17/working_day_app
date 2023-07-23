//
//  File.swift
//  
//
//  Created by erokha on 18.09.2022.
//

import Foundation
import Alamofire

extension VacationSession {
    
    //MARK: - Public
    
    public func post<Payload: Encodable>(url: String, payload: Payload) -> VacationDataRequest {
        let request = session.request(url, method: .post, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataRequest(dataRequest: request)
    }
    
    public func get<Payload: Encodable>(url: String, payload: Payload) -> VacationDataRequest {
        let request = session.request(url, method: .get, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataRequest(dataRequest: request)
    }
    
    public func put<Payload: Encodable>(url: String, payload: Payload) -> VacationDataRequest {
        let request = session.request(url, method: .put, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataRequest(dataRequest: request)
    }
    
    public func patch<Payload: Encodable>(url: String, payload: Payload) -> VacationDataRequest {
        let request = session.request(url, method: .patch, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataRequest(dataRequest: request)
    }
    
    public func delete<Payload: Encodable>(url: String, payload: Payload) -> VacationDataRequest {
        let request = session.request(url, method: .delete, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataRequest(dataRequest: request)
    }
    
}
