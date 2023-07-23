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
    
    public func get<
        Payload: Encodable,
        ReturnType
    >(
        url: String,
        payload: Payload,
        shouldMapResultTo: ReturnType.Type = ReturnType.self
    ) -> VacationDataTask<ReturnType> {
        let request = session.request(url, method: .get, parameters: payload, encoder: JSONParameterEncoder.prettyPrinted)
        logRequest(request: request)
        return VacationDataTask(request.serializingData())
    }
    
}
