import Foundation

public enum VacationCallback<Param, ReturnType> {
    case `default`((Param) -> ReturnType)
    case async((Param) async -> ReturnType)
    
    public init(
        _ callback: @escaping (Param) -> ReturnType
    ) {
        self = .default(callback)
    }
    
    public init(
        _ callback: @escaping (Param) async -> ReturnType
    ) {
        self = .async(callback)
    }

    public func call(_ param: Param) where ReturnType == Void {
        switch self {
        case .default(let callback):
            callback(param)
        case .async(let callback):
            Task { await callback(param) }
        }
    }
    
    public func asyncCall(_ param: Param) async -> ReturnType {
        switch self {
        case .default(let callback):
            return callback(param)
        case .async(let callback):
            return await callback(param)
        }
    }
}
